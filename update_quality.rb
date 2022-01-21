class UpdateQuality
  BLUECOMPARE_EXPIRATION_FIRST_STAGE = 10
  BLUECOMPARE_EXPIRATION_SECOND_STAGE = 5
  BLUESTAR_QUALITY_DECAY = 2
  DEFAULT_EXPIRATION_DECAY = 1
  DEFAULT_QUALITY_DECAY = 1
  DEFAULT_QUALITY_INCREASE = 1
  EXPIRATION = 0
  MAXIMUM_QUALITY = 50
  MINIMUM_QUALITY = 0

  def initialize(awards)
    @awards = awards
  end

  def update_quality
    @awards.each do |award|
      case award.name
      when 'Blue First'
        if below_maximum_quality?(award)
          increment_quality(award)
        end

        decrease_expiration(award)

        if below_minimum_quality?(award) && below_maximum_quality?(award)
          increment_quality(award)
        end
      when 'Blue Compare'
        if below_maximum_quality?(award)

          increment_quality(award)

          if below_bluecompare_expiration_first_stage?(award) && below_maximum_quality?(award)
              increment_quality(award)
          end
          if below_bluecompare_expiration_second_stage?(award) && below_maximum_quality?(award)
              increment_quality(award)
          end
        end

        decrease_expiration(award)

        if expired?(award)
          set_zero_quality(award)
        end

      when 'Blue Distinction Plus'
        # never decreases in quality
      when 'Blue Star'
        if above_minimum_quality?(award)
          decrease_bluestar_quality(award)
        end

        decrease_expiration(award)

        if expired?(award)
          if above_minimum_quality?(award)
            decrease_bluestar_quality(award)
          end
        end
      else
        if above_minimum_quality?(award)
          decrease_quality(award)
        end

        decrease_expiration(award)

        if expired?(award)
          if above_minimum_quality?(award)
            decrease_quality(award)
          end
        end
      end
    end
  end

  private

  def above_minimum_quality?(award)
    award.quality > MINIMUM_QUALITY
  end

  def below_maximum_quality?(award)
    award.quality < MAXIMUM_QUALITY
  end

  def below_minimum_quality?(award)
    award.quality < MINIMUM_QUALITY
  end

  def below_bluecompare_expiration_first_stage?(award)
    award.expires_in <= BLUECOMPARE_EXPIRATION_FIRST_STAGE
  end

  def below_bluecompare_expiration_second_stage?(award)
    award.expires_in <= BLUECOMPARE_EXPIRATION_SECOND_STAGE
  end

  def decrease_bluestar_quality(award)
    award.quality -= BLUESTAR_QUALITY_DECAY
  end

  def decrease_expiration(award)
    award.expires_in -= DEFAULT_EXPIRATION_DECAY
  end

  def decrease_quality(award)
    award.quality -= DEFAULT_QUALITY_DECAY
  end

  def expired?(award)
    award.expires_in < EXPIRATION
  end

  def increment_quality(award)
    award.quality += DEFAULT_QUALITY_INCREASE
  end

  def set_zero_quality(award)
    award.quality = award.quality - award.quality
  end
end
