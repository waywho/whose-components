# frozen_string_literal: true

require "tailwind_merge"

module Whose
  MERGER = TailwindMerge::Merger.new(config: {
    theme: {
      "color" => %w[accent accent-soft accent-text backdrop border canvas fg muted negative negative-soft
                     on-accent positive positive-soft subtle surface warning warning-soft],
      "radius" => [ "box" ]
    }
  })

  def self.merge_classes(*classes)
    MERGER.merge(classes.flatten.compact.join(" "))
  end
end
