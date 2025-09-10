#!/usr/bin/env nu

def main [] {
    print "Dev Tools - A collection of development utilities."
    print "Version 1.0.0"
    print ""
    print "Use -h or --help to see available commands and options."
}

def "main update" [] {
    print "Updating Dev Tools..."
    # Add update logic here

    (cd $env.HOME/.dev-tools; git pull origin main)

    print "Dev Tools updated successfully."
}

def "main init" [
    type = "dotnet",
    --name = "",
] {
    
    $env.LOCATION = (which tjip)
    $env.DESTINATION = (pwd)

    mut $projectName = $name
    if ($projectName == "") {
        $projectName = (input "Enter name of solution: ")
    }

    let $kebabCaseName = ($projectName | str replace -r '([a-z0-9])([A-Z])' '${1}-${2}' | str downcase)


    if ($type == "dotnet") {
        echo "Initializing .NET project..."
        # Add .NET specific initialization code here
        
        mkdir ($kebabCaseName | str downcase)
        cd ($kebabCaseName | str downcase)      

        (cp -r ~/.dev-tools/templates/*.* .)
        
        dotnet new sln -n $projectName
        dotnet new tool-manifest
        dotnet tool install docfx
        dotnet docfx init -y
        
        mkdir src
        (cp -r ~/.dev-tools/templates/src/*.* ./src)
        dotnet new webapi -n $projectName -o $"src/($projectName)"

        dotnet sln add $"src/($projectName)"

        mkdir test
        (cp -r ~/.dev-tools/templates/test/*.* ./test)
        dotnet new xunit -n $"($projectName).Tests" -o $"test/($projectName).Tests"
        dotnet sln add $"test/($projectName).Tests"

        mkdir tools
        mkdir build

        (main to-cpm)

        echo $"Project ($projectName) initialized with .NET structure."
    

    } else if ($type == "vue3") {
        echo "Initializing Vue3 project..."

    } else {
        echo "Unknown type: $type"
    }
}

def "main to-cpm" [] {
    # Scan all csproj files
    let projects = (ls **/*.csproj | get name)

    # Extract all PackageReference versions
    let packages = (
        $projects
        | each {|project|
            open $project
            | lines
            | where {|line| $line =~ '<PackageReference Include=.* Version=' } 
            | str trim  
            | parse '<PackageReference Include="{package}" Version="{version}" />'
        }
        | flatten
        | uniq
        | sort-by package
    )

    # Generate Directory.Packages.props content
    let header = $"<Project>\n<ItemGroup>"
    let footer = $"  </ItemGroup>\n</Project>"

    let body = (
        $packages
        | each { |pkg| $"    <PackageVersion Include=\"($pkg.package)\" Version=\"($pkg.version)\" />" }
        | str join "\n"
    )

    let props_content = $"($header)\n($body)\n($footer)\n"

    # Write the Directory.Packages.props file
    $props_content | save -f Directory.Packages.props

    # Remove versions from csproj files
    $projects | each {|project|
        let content = (
            open $project 
            | str replace -r '<PackageReference Include="(.*)" Version="(.*)"' '<PackageReference Include="$1"'
        )
        $content | save -f $project
    }

    print "✅ Central Package Management migration complete."
}


