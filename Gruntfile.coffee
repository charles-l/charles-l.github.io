gruntFunction = (grunt) ->
        gruntConfig =
                pkg:
                        grunt.file.readJSON 'package.json'
                less:
                        development:
                                files:
                                        "_src_css/main.css": "_less/*"
                cssmin:
                        "css/main.min.css": "_src_css/*.css"
                jekyll:
                        options:
                                src: './'
                        build: {}
                shell:
                        update_project_list:
                                command: 'ruby _scripts/generate_project_list.rb'


        grunt.initConfig gruntConfig

        grunt.loadNpmTasks 'grunt-contrib-cssmin'
        grunt.loadNpmTasks 'grunt-contrib-less'
        grunt.loadNpmTasks 'grunt-jekyll'
        grunt.loadNpmTasks 'grunt-shell'
        grunt.registerTask 'default', ['less', 'cssmin', 'shell']
        null

module.exports = gruntFunction
