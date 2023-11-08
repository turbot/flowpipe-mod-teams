# Teams Mod for Flowpipe

A collection of [Flowpipe](https://flowpipe.io) pipelines that can be used to:
- Create teams
- Manage members
- Manage channels
- And more!

<!-- ![image](https://github.com/turbot/flowpipe-mod-teams/blob/main/docs/images/flowpipe_test_run.png?raw=true) -->

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/teams/pipelines)**
- **[Triggers →](https://hub.flowpipe.io/mods/turbot/teams/triggers)**

## Getting started

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-teams.git
cd flowpipe-mod-teams
```

### Configuration

Configure your credentials:

```sh
cp flowpipe.pvars.example flowpipe.pvars
vi flowpipe.pvars
```

It's recommended to configure credentials through [input variables](https://flowpipe.io/docs/using-flowpipe/mod-variables) by setting them in the `flowpipe.pvars` file.

**Note:** Credentials can also be passed in each pipeline run with `--pipeline-arg acces_token=YourAccessToken`.

Additional input variables may be defined in the mod's `variables.hcl` file that can be configured to better match your environment and requirements.

Variables with defaults set do not need to be explicitly set, but it may be helpful to override them.

### Usage

Start the Flowpipe server to get started:

```sh
flowpipe service start
```

Run a pipeline:

```sh
flowpipe pipeline run list_teams
```

## Passing pipeline arguments

To pass values into pipeline [parameters](https://flowpipe.io/docs/using-flowpipe/pipeline-parameters), use the following syntax:

```sh
flowpipe pipeline run delete_team --pipeline-arg team_id=0f8b3036-1111-4f5c-99a8-d2e36c34cf12
```

Multiple pipeline args can be passed in with separate `--pipeline-arg` flags.

For more information on passing arguments, please see [Pipeline Args](https://flowpipe.io/docs/using-flowpipe/pipeline-arguments).

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/flowpipe-mod)) we would love you to join the community and start contributing.

- **[Join #flowpipe in our Slack community ](https://flowpipe.io/community/join)**

Please see the [contribution guidelines](https://github.com/turbot/flowpipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/flowpipe/blob/main/CODE_OF_CONDUCT.md).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Teams Mod](https://github.com/turbot/flowpipe-mod-teams/labels/help%20wanted)

## License

This mod is licensed under the [Apache License 2.0](https://github.com/turbot/flowpipe-mod-teams/blob/main/LICENSE).

Flowpipe is licensed under the [AGPLv3](https://github.com/turbot/flowpipe/blob/main/LICENSE).
