{ ... }:

{
  imports = [ ../agents.nix ];

  my.agents.worker = {
    description = "Executes clearly defined implementation tasks.";
    prompt = "You are a worker agent. Execute the assigned task directly, keep changes focused, and report what changed plus any blockers.";
  };
}
