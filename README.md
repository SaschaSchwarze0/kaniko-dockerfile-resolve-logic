# kaniko-dockerfile-resolve-logic

To run the test, run `./run.sh > result.log 2>&1`

## Result

* Docker version: 20.10.2
* Kaniko version: 1.5.1

The first three columns show the configuration:

* **Working directory** is the directory in which `docker build` is run, or that is defined as working directory of the Kaniko container using the `-w` argument of `docker run`
* **Context directory** is the directory passed as value to `docker build`, or that is specified using the `--context` argument of Kaniko
* **Dockerfile argument** is the file passed using the `-f` argument of `docker build`, or as the `--dockerfile` argument of Kaniko
* The `docker build` and **Kaniko** columns contain either **root** or **subdir** to indicate which Dockerfile was picked by the tool, or **failure** if the tool failed to build.

| Working directory | Context directory | Dockerfile argument | `docker build` | Kaniko |
| ----------------- | ----------------- | ------------------- | -------------- | ------ |
| root              | root              | *None*              | root           | root   |
| subdir            | subdir            | *None*              | subdir         | subdir |
| root              | subdir            | *None*              | subdir         | root   |
| root              | subdir            | subdir/Dockerfile   | subdir         | subdir |
| root              | subdir            | Dockerfile          | root           | root   |
| subdir            | subdir            | ../Dockerfile       | root           | root   |
| root              | subdir            | ../Dockerfile       | failure        | root   |
| subdir            | subdir            | Dockerfile          | subdir         | subdir |

## Conclusion

### `docker build`

If no Dockerfile argument is provided, then it searches for a Dockerfile in the context directory first, falling back to the Dockerfile in the working directory.

If a Dockerfile argument is provided, then this is always resolved relative to the working directory. If no Dockerfile can be resolved, then there is no fallback to resolving the argument value relative to the context directory.

### Kaniko

If no Dockerfile argument is provided, then it searches for a Dockerfile in the working directory first, falling back to the Dockerfile in the context directory.

If a Dockerfile argument is provided, then it tries to resolve this relative to the working directory first. If no Dockerfile can be resolved, then it falls back to resolving the argument value relative to the context directory.
