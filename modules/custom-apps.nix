{ inputs, ... }: {
  perSystem = { system, ... }: {
    # Keep the public flake package names while upstream maintains packaging.
    packages.helium = inputs.helium.packages.${system}.default;
    packages.chatgpt = inputs.llm-agents.packages.${system}.chatgpt;
  };
}
