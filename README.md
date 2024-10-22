# Microsoft Teams Mod for Flowpipe

Microsoft Teams pipeline library for [Flowpipe](https://flowpipe.io), enabling seamless integration of Microsoft Teams services into your workflows.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/teams/pipelines)**

## Getting Started

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

### Connections

By default, the following environment variables will be used for authentication:

- `TEAMS_ACCESS_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/teams.fpc
```

```hcl
connection "microsoft_teams" "default" {
  access_token = "<access_token>"
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

### Usage

[Initialize a mod](https://www.flowpipe.io/docs/mods/index#initializing-a-mod):

```sh
mkdir my_mod
cd my_mod
flowpipe mod init
```

[Install the Microsoft Teams mod](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies) as a dependency:

```sh
flowpipe mod install github.com/turbot/flowpipe-mod-teams
```

[Use the dependency](https://www.flowpipe.io/docs/mods/write-pipelines/index) in a pipeline step:

```sh
vi my_pipeline.fp
```

```hcl
pipeline "my_pipeline" {

  step "pipeline" "list_team_members" {
    pipeline = teams.pipeline.list_team_members
    args = {
      team_id = "abcdef01-2345-6789"
    }
  }
}
```

[Run the pipeline](https://www.flowpipe.io/docs/run/pipelines):

```sh
flowpipe pipeline run my_pipeline
```

### Developing

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-teams.git
cd flowpipe-mod-teams
```

List pipelines:

```sh
flowpipe pipeline list
```

Run a pipeline:

```sh
flowpipe pipeline run list_team_members --arg team_id=abcdef01-2345-6789
```

To use a specific `connection`, specify the `conn` pipeline argument:

```sh
flowpipe pipeline run list_team_members --arg team_id=abcdef01-2345-6789 --arg conn=connection.teams.teams_profile
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Microsoft Teams Mod](https://github.com/turbot/flowpipe-mod-teams/labels/help%20wanted)
