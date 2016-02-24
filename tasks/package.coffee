###
This file contains tasks only necessary for packaging and publishing Chosen
###
module.exports = (grunt) ->

  grunt.config 'dom_munger',
    latest_version:
      src: ['public/index.html', 'public/index.proto.html', 'public/options.html']
      options:
        callback: ($) ->
          $('#latest-version').text(grunt.config.get('version_tag'))

  grunt.config 'zip',
    chosen:
      cwd: 'public/'
      src: ['public/**/*']
      dest: 'chosen_<%= version_tag %>.zip'

  grunt.config 'gh-pages',
    options:
      base: 'public',
      message: 'Updated to new Chosen version <%= pkg.version %>'
    src: ['**']

  grunt.registerTask 'package-jquery', 'Update chosen.jquery.json', () ->
    json = grunt.file.readJSON('chosen.jquery.json')
    pkg = grunt.config.get('pkg')
    extra = pkg._extra

    json.title = extra.title
    json.maintainers = pkg.contributors
    json.licenses = [extra.license]
    json.keywords = pkg.keywords
    json.download = extra.links.download
    json.homepage = pkg.homepage
    json.docs = extra.links.docs
    json.bugs = pkg.bugs
    json.dependencies = pkg.dependencies
    json.version = pkg.version

    grunt.file.write('chosen.jquery.json', JSON.stringify(json, null, 2) + "\n")

  grunt.registerTask 'package-npm', 'Generate package/package.json', () ->
    pkg = grunt.config.get('pkg')

    json =
      name: "#{pkg.name}-jquery"
      version: pkg.version
      description: pkg.description
      keywords: pkg.keywords
      homepage: pkg.homepage
      bugs: pkg.bugs
      license: pkg.license
      contributors: pkg.contributors
      dependencies: pkg.dependencies
      files: pkg._extra.files
      main: pkg._extra.files[0]
      repository: pkg.repository

    grunt.file.write('package/package.json', JSON.stringify(json, null, 2) + "\n")

  grunt.registerTask 'package-bower', 'Generate package/bower.json', () ->
    pkg = grunt.config.get('pkg')
    extra = pkg._extra

    json =
      name: pkg.name
      description: pkg.description
      keywords: pkg.keywords
      homepage: pkg.homepage
      license: extra.license.url
      authors: pkg.contributors
      dependencies: pkg.dependencies
      main: extra.files
      ignore: []
      repository: pkg.repository

    grunt.file.write('package/bower.json', JSON.stringify(json, null, 2) + "\n")

  grunt.registerTask 'prep-release', ['build', 'dom_munger:latest_version', 'zip:chosen', 'package-jquery', 'package-npm', 'package-bower']
  grunt.registerTask 'publish-release', ['gh-pages']
