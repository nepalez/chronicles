# encoding: utf-8

describe Chronicles::Updater do

  let(:test_class) do
    Class.new do
      define_method(:chronicles) { @chronicles ||= [] }
      define_method(:foo) { |arg = nil| arg || :foo }
      define_method(:bar) { :bar }
      define_method(:baz) { :baz }

      protected :bar
      private :baz
    end
  end

  let(:object) { test_class.new }
  let(:name)   { :foo }
  let(:code)   { "chronicles << :foo" }
  subject      { described_class.new object, name, code }

  describe ".new" do

  end # describe .new

  describe "#object" do

    it "is initialized" do
      expect(subject.object).to eq object
    end

  end # describe #object

  describe "#name" do

    it "is initialized" do
      expect(subject.name).to eq name
    end

  end # describe #name

  describe "#code" do

    it "is initialized" do
      expect(subject.code).to eq code
    end

  end # describe #code

  describe "#type" do

    context "for public method's #name" do

      subject { described_class.new object, :foo }

      it "returns 'public'" do
        expect(subject.type).to eq "public"
      end

    end # context

    context "for protected method's #name" do

      subject { described_class.new object, :bar }

      it "returns 'protected'" do
        expect(subject.type).to eq "protected"
      end

    end # context

    context "for private method's #name" do

      subject { described_class.new object, :baz }

      it "returns 'private'" do
        expect(subject.type).to eq "private"
      end

    end # context

  end # describe #type

  describe "#klass" do

    it "returns #object's singleton class" do
      expect(subject.klass).to eq object.singleton_class
    end

  end # describe #klass

  describe "#run" do

    context "with existing code" do

      it "invokes the original method" do
        object.singleton_class.send(:define_method, :foo) { :bar }
        expect { subject.run }.to change { object.foo }.from(:bar).to(:foo)
      end

      it "preserves the original method arguments" do
        subject.run
        expect(object.foo(:baz)).to eq :baz
      end

      it "prepends the original method with code" do
        subject.run
        expect { object.foo }.to change { object.chronicles }.from([]).to [:foo]
      end

      it "keeps the method public" do
        subject.run
        expect(object.public_methods).to include :foo
      end

      it "keeps the method protected" do
        subject = described_class.new object, :bar
        subject.run
        expect(object.protected_methods).to include :bar
      end

      it "keeps the method private" do
        subject = described_class.new object, :baz
        subject.run
        expect(object.private_methods).to include :baz
      end

    end # context

    context "with empty code" do

      before { allow(subject).to receive(:code) }

      it "restores the original method" do
        object.singleton_class.send(:define_method, :foo) { :bar }
        expect { subject.run }.to change { object.foo }.from(:bar).to(:foo)
      end

    end # context

  end # describe #run

end # describe Chronicles::Updater
