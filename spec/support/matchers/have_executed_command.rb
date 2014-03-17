RSpec::Matchers.define :have_executed_command do |command|
  match do |shell|
    shell.commands.include?(command)
  end

  failure_message_for_should do |shell|
    "Expected shell to execute command:\n  #{command}\n\n" \
      "But got #{inspect_commands(shell.commands)}"
  end

  def inspect_commands(commands)
    if commands.any?
      "commands:\n" +
        shell.commands.map { |command| "  #{command}" }.join("\n")
    else
      'no commands'
    end
  end
end
