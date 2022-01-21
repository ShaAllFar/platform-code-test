require 'award_updater'

class UpdateQuality


  def initialize(awards)
    @awards = awards
  end

  def update_quality

    @awards.each do |award|
      updater = AwardUpdater.new(award)

      case award.name
      when 'Blue First'
        if updater.below_maximum_quality?
          updater.increment_quality
        end

        updater.decrease_expiration

        if updater.below_minimum_quality? && updater.below_maximum_quality?
          updater.increment_quality
        end
      when 'Blue Compare'
        if updater.below_maximum_quality?

          updater.increment_quality

          if updater.below_bluecompare_expiration_first_stage? && updater.below_maximum_quality?
              updater.increment_quality
          end
          if updater.below_bluecompare_expiration_second_stage? && updater.below_maximum_quality?
              updater.increment_quality
          end
        end

        updater.decrease_expiration

        if updater.expired?
          updater.set_zero_quality
        end

      when 'Blue Distinction Plus'
        # never decreases in quality
      when 'Blue Star'
        if updater.above_minimum_quality?
          updater.decrease_bluestar_quality
        end

        updater.decrease_expiration

        if updater.expired?
          if updater.above_minimum_quality?
            updater.decrease_bluestar_quality
          end
        end
      else
        if updater.above_minimum_quality?
          updater.decrease_quality
        end

        updater.decrease_expiration

        if updater.expired?
          if updater.above_minimum_quality?
            updater.decrease_quality
          end
        end
      end
    end
  end
end
