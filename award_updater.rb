class AwardUpdater
  BLUECOMPARE_EXPIRATION_FIRST_STAGE = 10
  BLUECOMPARE_EXPIRATION_SECOND_STAGE = 5
  BLUESTAR_QUALITY_DECAY = 2
  DEFAULT_EXPIRATION_DECAY = 1
  DEFAULT_QUALITY_DECAY = 1
  DEFAULT_QUALITY_INCREASE = 1
  EXPIRATION = 0
  MAXIMUM_QUALITY = 50
  MINIMUM_QUALITY = 0

  def initialize(award)
    @award = award
  end

  def above_minimum_quality?
    @award.quality > MINIMUM_QUALITY
  end

  def below_maximum_quality?
    @award.quality < MAXIMUM_QUALITY
  end

  def below_minimum_quality?
    @award.quality < MINIMUM_QUALITY
  end

  def below_bluecompare_expiration_first_stage?
    @award.expires_in <= BLUECOMPARE_EXPIRATION_FIRST_STAGE
  end

  def below_bluecompare_expiration_second_stage?
    @award.expires_in <= BLUECOMPARE_EXPIRATION_SECOND_STAGE
  end

  def decrease_bluestar_quality
    @award.quality -= BLUESTAR_QUALITY_DECAY
  end

  def decrease_expiration
    @award.expires_in -= DEFAULT_EXPIRATION_DECAY
  end

  def decrease_quality
    @award.quality -= DEFAULT_QUALITY_DECAY
  end

  def expired?
    @award.expires_in < EXPIRATION
  end

  def increment_quality
    @award.quality += DEFAULT_QUALITY_INCREASE
  end

  def set_zero_quality
    @award.quality = @award.quality - @award.quality
  end
end
