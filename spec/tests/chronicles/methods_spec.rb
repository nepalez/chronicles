# encoding: utf-8

describe Chronicles::Methods do

  before do
    class Test
      attr_reader :chronicles, :start_chronicles, :stop_chronicles
      attr_reader :foo, :bar, :baz
      protected :bar
      private :baz
    end
  end
  let(:object) { Test.new }
  after        { Object.send :remove_const, :Test }

  subject { described_class.new(object) }

  describe ".new" do

    it "creates an array" do
      expect(subject).to be_kind_of Array
    end

    context "by default" do

      it { is_expected.to match_array %i(foo bar baz) }

    end # context

    context "public: false" do

      subject { described_class.new object, public: false }
      it      { is_expected.to match_array %i(bar baz) }

    end # context

    context "protected: false" do

      subject { described_class.new object, protected: false }
      it      { is_expected.to match_array %i(foo baz) }

    end # context

    context "private: false" do

      subject { described_class.new object, private: false }
      it      { is_expected.to match_array %i(foo bar) }

    end # context

    context "except: ['foo', 'bar']" do

      subject { described_class.new object, except: %w(foo bar) }
      it      { is_expected.to match_array %i(baz) }

    end # context

    context "except: 'foo'" do

      subject { described_class.new object, except: "foo" }
      it      { is_expected.to match_array %i(bar baz) }

    end # context

    context "only: ['foo', 'bar']" do

      subject { described_class.new object, only: %w(foo bar) }
      it      { is_expected.to match_array %i(foo bar) }

    end # context

    context "only: 'foo'" do

      subject { described_class.new object, only: "foo" }
      it      { is_expected.to match_array %i(foo) }

    end # context

    context "only: %w(foo baz), private: false" do

      subject { described_class.new object, only: %w(foo baz), private: false }
      it      { is_expected.to match_array %i(foo) }

    end # context

  end # describe .new

end # describe Chronicles::Methods
