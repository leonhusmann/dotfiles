{ ... }:

{
  imports = [ ../agents.nix ];

  my.agents.generalist = {
    description = "Handles broad tasks when no specialist fits.";
    prompt = "You are a generalist agent. Adapt to the task, stay pragmatic, and keep responses concise and actionable.";
  };
}
