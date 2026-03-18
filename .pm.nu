
# Completions for pm.

#

def "nu-complete pm projects" [] {
  ^project-manager --list
  | lines
  | each { |l|
      let parts = ($l | split row ": ")
      { value: ($parts | first), description: ($parts | last) }
  }
}

def "nu-complete pm first-arg" [] {
  let flags = [
    { value: "--new",    description: "Add current directory as a new project" },
    { value: "--remove", description: "Remove a project" },
  ]
  $flags | append (nu-complete pm projects)
}

# =============================================================================
# Command for pm.
#

def --env pm [
  action?: string@"nu-complete pm first-arg",
  name?: string@"nu-complete pm projects",
] {
  match $action {
    "--new" => {
      if $name == null {
        error make { msg: "Usage: pm --new <project_name>" }
      }
      ^project-manager --new $name
    }

    "--remove" => {
      if $name != null {
        ^project-manager --remove $name
      } else {
        let selected = (
          ^project-manager --list
          | lines
          | each { |l| $l | split row ": " | first }
          | str join "\n"
          | ^fzf --prompt="Remove project: "
          | str trim -r -c "\n"
        )
        if $selected != "" {
          ^project-manager --remove $selected
        }
      }
    }

    null => {
      let selected = (
        ^project-manager --list
        | lines
        | each { |l| $l | split row ": " | first }
        | str join "\n"
        | ^fzf --prompt="Project: "
        | str trim -r -c "\n"
      )
      if $selected != "" {
        cd (^project-manager --project $selected | str trim -r -c "\n")
      }
    }

    _ => {
      # treat as project name
      cd (^project-manager --project $action | str trim -r -c "\n")
    }
  }
}

