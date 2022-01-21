require 'rspec'
require 'award'
require 'update_quality'


describe UpdateQuality do

  context 'Given a single award' do
    let(:initial_expires_in) { 5 }
    let(:initial_quality) { 10 }
    let(:award) { Award.new(name, initial_expires_in, initial_quality) }
    let(:updater) { UpdateQuality.new([award]) }
    context 'when quality is updated' do
      before do
        updater.update_quality
      end

      context 'given a normal award' do
        let(:name) { 'NORMAL ITEM' }

        before do
          # Verify that this is always true in the current context
          expect(award.expires_in).to eq(initial_expires_in-1)
        end

        context 'before expiration date' do
          specify { expect(award.quality).to eq(initial_quality-1) }
        end

        context 'on expiration date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality-2) }
        end

        context 'after expiration date' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality-2) }
        end

        context 'of zero quality' do
          let(:initial_quality) { 0 }
          specify { expect(award.quality).to eq(0) }
        end
      end

      context 'given Blue First' do
        let(:name) { 'Blue First' }

        before do
          # Verify that this is always true in the current context
          award.expires_in.should == initial_expires_in-1
        end

        context 'before expiration date' do
          specify { expect(award.quality).to eq(initial_quality+1) }

          context 'with max quality' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        # context 'on expiration date' do
        #   let(:initial_expires_in) { 0 }
        #   specify { expect(award.quality).to eq(initial_quality+2) }
        #
        #   context 'near max quality' do
        #     let(:initial_quality) { 49 }
        #     specify { expect(award.quality).to eq(50) }
        #   end
        #
        #   context 'with max quality' do
        #     let(:initial_quality) { 50 }
        #     specify { expect(award.quality).to eq(initial_quality) }
        #   end
        # end
        #
        # context 'after expiration date' do
        #   let(:initial_expires_in) { -10 }
        #   specify { expect(award.quality).to eq(initial_quality+2) }
        #
        #   context 'with max quality' do
        #     let(:initial_quality) { 50 }
        #     specify { expect(award.quality).to eq(initial_quality) }
        #   end
        # end
      end

      context 'given Blue Distinction Plus' do
        let(:initial_quality) { 80 }
        let(:name) { 'Blue Distinction Plus' }

        before do
          # Verify that this is always true in the current context
          award.expires_in.should == initial_expires_in
        end

        context 'before expiration date' do
          specify { expect(award.quality).to eq(initial_quality) }
        end

        context 'on expiration date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality) }
        end

        context 'after expiration date' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality) }
        end
      end

      context 'given Blue Compare' do
        let(:name) { 'Blue Compare' }

        before do
          # Verify that this is always true in the current context
          award.expires_in.should == initial_expires_in-1
        end

        context 'long before expiration date' do
          let(:initial_expires_in) { 11 }
          specify { expect(award.quality).to eq(initial_quality+1) }

          context 'at max quality' do
            let(:initial_quality) { 50 }
          end
        end

        context 'medium close to expiration date (upper bound)' do
          let(:initial_expires_in) { 10 }
          specify { expect(award.quality).to eq(initial_quality+2) }

          context 'at max quality' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'medium close to expiration date (lower bound)' do
          let(:initial_expires_in) { 6 }
          specify { expect(award.quality).to eq(initial_quality+2) }

          context 'at max quality' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'very close to expiration date (upper bound)' do
          let(:initial_expires_in) { 5 }
          specify { expect(award.quality).to eq(initial_quality+3) }

          context 'at max quality' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'very close to expiration date (lower bound)' do
          let(:initial_expires_in) { 1 }
          specify { expect(award.quality).to eq(initial_quality+3) }

          context 'at max quality' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'on expiration date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(0) }
        end

        context 'after expiration date' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(0) }
        end
      end

      context 'given a Blue Star award' do
        let(:name) { 'Blue Star' }
        before { award.expires_in.should == initial_expires_in-1 }

        context 'before the expiration date' do
          let(:initial_expires_in) { 5 }
          specify { expect(award.quality).to eq(initial_quality-2) }

          context 'at zero quality' do
            let(:initial_quality) { 0 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'on expiration date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality-4) }

          context 'at zero quality' do
            let(:initial_quality) { 0 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'after expiration date' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality-4) }

          context 'at zero quality' do
            let(:initial_quality) { 0 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end
      end
    end
  end

  context 'Given several award' do
    let(:awards) {
      [
        Award.new('NORMAL ITEM', 5, 10),
        Award.new('Blue First', 3, 10),
      ]
    }
    let(:updater) { UpdateQuality.new(awards) }

    context 'when quality is updated' do
      before do
        updater.update_quality
      end

      specify { expect(awards[0].quality).to eq(9) }
      specify { expect(awards[0].expires_in).to eq(4) }

      specify { expect(awards[1].quality).to eq(11) }
      specify { expect(awards[1].expires_in).to eq(2) }
    end
  end
end
