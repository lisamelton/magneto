# Magneto

Magneto is a static site generator.

## About

Hi, I'm Don Melton. I wrote Magneto to generate [my own website](http://donmelton.com/). Magneto was inspired by [nanoc](http://nanoc.stoneship.org/) and [Jekyll](http://jekyllrb.com/), but it's a much simpler tool with fewer features and less policy.

For example, Magneto is not "blog aware" like some other systems, but it allows you to write a site controller script and plugins which can easily generate blog posts, an index page and a RSS feed. This is how I use it. There may be more work up front compared to other tools, but Magneto gives you very precise control over its behavior and output.

Before using Magneto, realize that it does have limitations due to its simplicity and that its programming interface may change because it's still under development.

## Installation

Magneto is [available as a gem](https://rubygems.org/gems/magneto) which you can install like this:

    sudo gem install magneto

## Usage

    magneto [OPTION]...

Source file items, their templates and the site controller script are loaded from the `items` and `templates` directories and from the `script.rb` file, all within the current directory. These are watched for changes and reloaded when automatic regeneration is enabled.

Ruby library files are loaded from the `plugins` directory only once.

The generated site is written to the `output` directory.

Configuration is loaded from `config.yaml` but can be overriden using the following options:

    -c, --config PATH                use specific YAML configuration file
    -s, --source PATH                use specific source directory
    -o, --output PATH                use specific output directory

        --[no-]hidden                include [exclude] hidden source files
        --[no-]remove                remove [keep] obsolete output
        --[no-]auto                  enable [disable] automatic regeneration

    -h, --help                       display this help and exit
        --version                    output version information and exit

## Dependencies

Magneto doesn't have any dependencies for basic operation.

Enabling automatic regeneration requires installation of the Directory Watcher gem:

    sudo gem install directory_watcher

Using any of the built-in filters could require additional gem installations.

## License

Magneto is copyright Don Melton and available under a [MIT license](https://github.com/donmelton/magneto/blob/master/LICENSE).
