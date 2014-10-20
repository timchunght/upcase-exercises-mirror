module Upcase
  class ExerciseObserver
    pattr_initialize [:upcase_client!, :url_helper!]

    def saved(exercise)
      upcase_client.synchronize_exercise(
        title: exercise.title,
        url: url_helper.exercise_url(exercise),
        summary: exercise.summary,
        uuid: exercise.uuid
      )
    end

    def created(_exercise)
    end

    def updated(_exercise)
    end
  end
end
