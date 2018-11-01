def force_occurrence(name)
  Occurrence.where(name: name).first.update(force: true)
end

def suppress_occurrence(name)
  Occurrence.where(name: name).first.update(suppress: true)
end

def no_occurrences
  allow_any_instance_of(Occurrence).to receive(:occur?).and_return(false)
end
