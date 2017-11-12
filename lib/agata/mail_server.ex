defmodule Agata.MailServer do
  @behaviour :gen_smtp_server_session

  def init(host_name, _, _, _) do
    {:ok, [host_name, "ESTP"], %{}}
  end

  def terminate(reason, state) do
    {:ok, reason, state}
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def store_email(data) do
    email = build_email(data)

    {attachments, email} = Map.get_and_update(email, :attachments, fn value ->
      {value, Enum.map(value, &(&1.file_name))}
    end)

    save_attachments_to_disk(attachments)

    Agata.Storage.set(email.id, email)

    Poison.encode!(email) |> Agata.Clients.send_message
  end

  def build_email(data) do
    email = Mailman.Email.parse!(data)
            |> Map.put(:id, :os.system_time(:micro_seconds))
            |> Map.put(:unread, true)
            |> Map.put(:data, %{})

    Map.put(email, :html, remove_script_tags(email.html))
  end

  def save_attachments_to_disk(attachments) do
    if attachments |> Enum.any? do
      Enum.each attachments, fn attachment ->
        File.write("priv/tmp/#{attachment.file_name}", attachment.data)
      end
    end
  end

  def remove_script_tags(html) do
    ~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/ |> Regex.replace(html, "", global: true)
  end

  def code_change(_, state, _) do
    {:ok, state}
  end

  def handle_MAIL(_, state) do
    {:ok, state}
  end

  def handle_MAIL_extension(_, state) do
    {:ok, state}
  end

  def handle_RCPT(_, state) do
    {:ok, state}
  end

  def handle_RCPT_extension(_, state) do
    {:ok, state}
  end

  def handle_call(:state, _, state) do
    {:reply, state, state}
  end

  def handle_DATA(_, from, data, state) do
    store_email(data)

    {:ok, from, state}
  end

  def handle_HELO(_, state) do
    {:ok, state}
  end

  def handle_EHLO(_, extensions, state) do
    {:ok, extensions, state}
  end

  def handle_RSET(state) do
    state
  end

  def handle_VRFY(_, state) do
    {:error, "252 VRFY disabled by policy, just send some mail", state}
  end

  def handle_other(verb, _, state) do
    {['500 Error: command not recognized : \'', verb, '\''], state}
  end

  def handle_STARTTLS(state) do
    state
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
