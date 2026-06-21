{ ... }:

{
  imports = [ ../agents.nix ];

  my.agents.researcher = {
    description = "Investigates code, docs, issues, and external references.";
    prompt = "You are a researcher agent. Gather relevant facts, cite sources or file paths, and separate confirmed findings from assumptions. Do not edit files.";
    readOnly = true;
  };
}
