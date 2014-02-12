require "mappy/resolver"
require "mappy/target_builder_factory"

module Mappy

  class Configuration
    attr_reader :map_store
    def initialize(config = {})
      @map_store = config.fetch(:map_store) { {} }
    end

    def legend(options = {})
      source = options.fetch(:source)
      target = options.fetch(:target)
      legend = options.fetch(:legend)

      map_store[target] ||= {}
      map_store[target][source] = legend
    end

    def map(source_instance, options = {})
      source = source_instance.to_mappy_type
      target = options.fetch(:target)
      target_builder_finder = options.fetch(:target_builder_finder) { Mappy::TargetBuilderFactory }
      legend = map_store.fetch(target).fetch(source)

      target_builder = target_builder_finder.call(target)

      # @Todo: The returned value should not be an OpenStruct, but should
      # be an instance of the target (as per some Mappy resolver).
      Resolver.new(
        target_builder: target_builder,
        legend: legend
      ).call(source_instance)
    end
  end

end