mod "teams" {
  title         = "Microsoft Teams"
  description   = "Run pipelines to supercharge your Mircosoft Teams workflows using Flowpipe."
  color         = "#4E5FBF"
  documentation = file("./README.md")
  icon          = "/images/mods/turbot/teams.svg"
  categories    = ["library", "messaging"]

  opengraph {
    title       = "Microsoft Teams Mod for Flowpipe"
    description = "Run pipelines to supercharge your Mircosoft Teams workflows using Flowpipe."
    image       = "/images/mods/turbot/teams-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
