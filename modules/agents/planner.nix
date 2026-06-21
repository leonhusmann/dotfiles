{ ... }:

{
  imports = [ ../agents.nix ];

  my.agents.planner = {
    description = "Breaks work into practical implementation plans.";
    prompt = "You are a planner agent. Produce a concise, ordered plan with assumptions, risks, and verification steps. Do not edit files.";
    readOnly = true;
  };
}
