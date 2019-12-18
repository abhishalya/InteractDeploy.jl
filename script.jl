using Pkg

index_template = """
using Interact, Mux

b = button("Click me")
ui = hbox(b, observe(b))

port = parse(Int64, ARGS[1])
wait(WebIO.webio_serve(page("/", req -> ui), port))
"""

procfile_template = """
web: julia --project index.jl \$PORT
"""

function create_index(path)
    open(joinpath(path, "index.jl"), "w") do f
        write(f, index_template)
    end
end

function create_procfile(path)
    open(joinpath(path, "Procfile"), "w") do f
        write(f, procfile_template)
    end
end

function create_project_toml(path)
    Pkg.activate(path)
    Pkg.add("Interact")
    Pkg.add("Mux")
end

function check_if_exists(path, cwd; file = true)
    if file
        return isfile(joinpath(cwd, path))
    end
    return isdir(joinpath(cwd, path))
end

function main()
    directory_name = ""
    app_name = "my-default-app-name"
    cwd = pwd()
    try
        directory_name = ARGS[1]
    catch
        println("No directory provided.")
        exit(1)
    end
    try
        app_name = ARGS[2]
    catch
        println("No appname provided.")
    end
    if !check_if_exists(directory_name, cwd, file = false)
        mkdir(joinpath(cwd, directory_name))
    end
    if !check_if_exists("$directory_name/index.jl", cwd)
        create_index(directory_name)
    end
    if !check_if_exists("$directory_name/Procfile", cwd)
        create_procfile(directory_name)
    end
    if !check_if_exists("$directory_name/Project.toml", cwd)
        create_project_toml(directory_name)
    end

    cd(joinpath(cwd, "$directory_name"))
    run(`git init`)
    run(`heroku create "$app_name" --buildpack https://github.com/Optomatica/heroku-buildpack-julia.git`)
    run(`git add -A`)
    run(`git commit -m "Initial commit"`)
    run(`git push heroku master`)
end

main()
