# frozen_string_literal: true

class LivingDocument::CapturingStringIO < StringIO
  def puts(*printed_values)
    $printed_objects += printed_values
  end
end
