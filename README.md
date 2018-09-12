# Easy-dep
attention, WIP

A tool that creates hashmap between webhook url and script.
Allows to observe script output and invoke script by hand.

## Usage
Extend from this docker image and install things you may want to use in webhooks.
Currently base image is alpine, so if you want your script to orchestrate docker:
```
FROM animaacija/easy-dep
RUN apk update
RUN apk add docker
```
then just bind as docker.sock and observe webhooked script output in this easy-dep's frontend

example config.json:
```
{
  "hooks": [
    {
      "name": "feature deploy",
      "path": "/some-web-hook",
      "script": {
        "bin": "bash",
        "args": [
          "./path/to.sh"
        ]
      }
    }
  ]
}
```
`d run -p 80:3000 -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/conf.json:/home/conf.json -v $PWD/scripts:/home/scripts animaacija/easy-dep`

## Examples
Each example may be previewed as service.

`docker-compose -f ./examples/docker-compose.yml up proxy docker plain`
then visit: docker.easy-dep.localhost or plain.easy-dep.localhost

## Development
`. ./dev`

## Contributing

1. Fork it (<https://github.com/talbergs/easy-dep/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [talbergs](https://github.com/talbergs) Martins Talbergs - creator, maintainer

TODO: Transbuild ubuntu/alpine and more
TODO: Execute arbitrary code (repl)


## techs used:
 - css-grid
 - cerebraljs,react,parcel,sass
 - crystal-lang (kemal)
 - traefik
 - docker-compose


