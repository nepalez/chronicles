# encoding: utf-8

describe Chronicles do

  let(:test_class) do
    Class.new do
      include Chronicles

      attr_reader :foo

      protected

      attr_reader :bar

      private

      attr_reader :baz
    end
  end

  subject { test_class.new }

  describe "#chronicles" do

    it "returns an empty array" do
      expect(subject.chronicles).to eq []
    end

  end # describe #chronicles

  describe "#start_chronicles" do

    context "by default" do

      before do
        subject.start_chronicles
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "starts looking for all methods" do
        expect(subject.chronicles).to eq %i(foo bar baz foo)
      end

    end # context

    context "public: false" do

      before do
        subject.start_chronicles public: false
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "starts looking for proper methods" do
        expect(subject.chronicles).to eq %i(bar baz)
      end

    end # context

    context "protected: false" do

      before do
        subject.start_chronicles protected: false
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "starts looking for proper methods" do
        expect(subject.chronicles).to eq %i(foo baz foo)
      end

    end # context

    context "private: false" do

      before do
        subject.start_chronicles private: false
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "starts looking for proper methods" do
        expect(subject.chronicles).to eq %i(foo bar foo)
      end

    end # context

    context "except: foo" do

      before do
        subject.start_chronicles except: :foo
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "starts looking for proper methods" do
        expect(subject.chronicles).to eq %i(bar baz)
      end

    end # context

    context "only: foo" do

      before do
        subject.start_chronicles only: :foo
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "starts looking for proper methods" do
        expect(subject.chronicles).to eq %i(foo foo)
      end

    end # context

  end # describe #start_chronicles

  describe "#stop_chronicles" do

    before { subject.start_chronicles }

    context "by default" do

      before do
        subject.stop_chronicles
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "stops looking for all methods" do
        expect(subject.chronicles).to eq []
      end

    end # context

    context "public: false" do

      before do
        subject.stop_chronicles public: false
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "stops looking for proper methods" do
        expect(subject.chronicles).to eq %i(foo foo)
      end

    end # context

    context "protected: false" do

      before do
        subject.stop_chronicles protected: false
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "stops looking for proper methods" do
        expect(subject.chronicles).to eq %i(bar)
      end

    end # context

    context "private: false" do

      before do
        subject.stop_chronicles private: false
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "stops looking for proper methods" do
        expect(subject.chronicles).to eq %i(baz)
      end

    end # context

    context "except: foo" do

      before do
        subject.stop_chronicles except: :foo
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "stops looking for proper methods" do
        expect(subject.chronicles).to eq %i(foo foo)
      end

    end # context

    context "only: foo" do

      before do
        subject.stop_chronicles only: :foo
        %i(foo bar baz foo).each(&subject.method(:send))
      end

      it "stops looking for proper methods" do
        expect(subject.chronicles).to eq %i(bar baz)
      end

    end # context

  end # describe #stop_chronicles

end # describe Chronicles
