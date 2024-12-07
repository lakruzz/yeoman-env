# Yeoman Environment
The purpose is to setup a containerized environment to run [Yeoman scaffolding genrator](https://yeoman.io).


# Prerequsites:
- Docker (Docker Desktop)
  - Buildx
- VS Code
- Git


## 1: Tweak the docker file(s) or create your own
You may want to tweak any of the `dockerfile`s before you build and run the container.

Specifically adjust the list of generators you need:


```dockerfile
# Install Yeoman and the specific generators
RUN npm install -g yo \
   generator-office \
   generator-fountain-webapp 
```

Say you also need support for another generator, you could add it the list and rebuild.

Or  — as you'll see later you can install it using `npm` in the running container.

## 2: Build the docker file (`dockerfile`)

The following command will build the container (If you change the tag or the version, you'll need to change it in step 3 too).

```shell
 docker buildx build --tag ubuntu-yo:latest . 
```

## 3: Run the `yo` command

Two options are common. But before you run any of them you should `cd` into the directory where you want the scaffolding code from `yo` to end up.

Say you want to run the òffice` generator like this:

```shell
yo office
```

#### Option: Run it as if it was a local command

```shell
docker run \
  -it \
  --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ubuntu-yo:latest office
```
This way you can apply all the usual switches to the execution as you would to `yo` if it was installed locally.

Admitted, it's a tad verbose so you can use the `yo` script in this repo to make it easier on youself

Examples
```shell
./yo --help
./yo office
```

You can even make it available from your path like this:

```shell
sudo cp ./yo /usr/local/bin
```
and then run
```shell
yo office
```
#### Option: Enter into the container and run from inside it

Another approach that can be handy, or just more to your liking is to run it interactively with your current directoy mapped into the container. Simply override the `ENTRYPOINT` to be the `bash` shell. This way, you don't have to change and rebuild the container if you want to add more generators, you simply install them with `npm` once you are inside the container:

```shell
docker run \
  -it \
  --rm  \
  --pid=host \
  -v /$(pwd)://workspace:rw \
  --workdir //workspace  \
  --entrypoint /bin/bash \
  ubuntu-yo:latest 
```

Once inside try:

```shell
yo
yo --help
yo office
```
Or say you wanted to use the [azure-devops-extension](https://github.com/davidpolaniaac/generator-azure-devops-extension) generator:

```shell
npm install -g generator-azure-devops-extension
yo azure-devops-extension
```

or one of the [5600+ others](https://yeoman.io/generators/)

Each generato will have it's own set of switches it support.
