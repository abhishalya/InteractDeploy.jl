# interact-deploy

This is a simple utility to deploy your
[Interact.jl](https://github.com/JuliaGizmos/Interact.jl) apps to
[Heroku](https://heroku.com).

# Usage

## Pre-requisites

You need to have heroku-cli installed before using this script. You can follow
the instructions
[here](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
to install it. Also, after you've installed heroku-cli make sure you are logged
in. You can simply run `heroku login` in order to do that.

You also need to have git installed. You can follow the instructions
[here](https://www.atlassian.com/git/tutorials/install-git) to install git.

Apart from these, I expect you should already have Julia installed and has
been added to the `$PATH` variable.

## Instructions

* The script accepts at most two arguments with the first one being the
name of the directory and the other being the name of the app. Ideally, you
should provide both of the arguments since the default app name may not be
available.

* To manage the dependencies of your project, you'll need a Project.toml file
and a Manifest.toml file. The script creates a default for both of the files,
but you're expected to create them yourselves since your app might have other
dependencies as well.

To create a new Project.toml for you app, do follow the below steps below in the
root directory of the app:
```jl
julia> using Pkg;

julia> Pkg.activate(".")

julia> Pkg.add("foo")

julia> Pkg.add("bar")
```

This will create both of the files in that directory with the packages `foo`
and `bar` as your dependencies. You should add all of your packages this way.

* Finally, assuming your app directory name is `test-dir` and the app name you
want to set is `my-new-app`, simply run:

```
julia script.jl path/to/test-dir my-new-app
```

That's it. This will do most of the work and will deploy your app on heroku.
You can watch the log to see if everything went fine.
