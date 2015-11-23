require_relative 'proc_extensions/version'
require_relative 'proc_extensions/proc_source'

require_relative 'core_extensions/proc/inspect'
require_relative 'core_extensions/proc/match'
require_relative 'core_extensions/proc/source'

# TODO: support symbol procs
# TODO: support procs returned from an eval
# TODO: handle procs where source extraction fails
# TODO: split proc equals logic into its own gem
# TODO: clean up README.md
