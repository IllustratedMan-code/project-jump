
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

# def "nu-complete pm first-arg" [] {
#   let flags = [
#     { value: "--new",    description: "Add current directory as a new project" },
#     { value: "--remove", description: "Remove a project" },
#   ]
#   $flags | append (nu-complete pm projects)
# }

# =============================================================================
# Command for pm.
#

def --env pm [
  project?: string@"nu-complete pm projects" # switch to project
  --new: string # add current dir to projects
  --remove: string@"nu-complete pm projects" # remove project
] {

  if $project != null {
    cd (project-manager --project $project)
  } else if $new != null {
    project-manager --new $new
  } else if $remove != null {
    project-manager --remove $remove
  } else {
      let selected = (
        ^project-manager --list
        | ^fzf --prompt="Project: "
        | split row ": "
	| first 
      )
      if $selected != "" {
        cd (^project-manager --project $selected )
      }
  }
}
