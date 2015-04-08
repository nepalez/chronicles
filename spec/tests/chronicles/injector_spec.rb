# encoding: utf-8

describe Chronicles::Injector do

  let(:object)  { double foo: nil, bar: nil, baz: nil       }
  let(:options) { { only: %i(foo bar), private: false }     }
  let(:code)    { "chronicles << __method__"                }
  subject       { described_class.new object, code, options }

  describe "#object" do

    it "is initialized" do
      expect(subject.object).to eq object
    end

  end # describe #object

  describe "#list" do

    let(:list) { Chronicles::Methods.new(object, options).to_a }

    it "is initialized" do
      expect(subject.list).to eq list
    end

  end # describe #list

  describe "#code" do

    it "is initialized" do
      expect(subject.code).to eq code
    end

    it "can be nil" do
      subject = described_class.new object, options
      expect(subject.code).to be_nil
    end

  end # describe #code

  describe "#updaters" do

    let(:list) { %i(foo bar baz) }
    before     { allow(subject).to receive(:list).and_return list }

    it "returns updaters" do
      subject.updaters.each do |updater|
        expect(updater).to be_kind_of Chronicles::Updater
      end
    end

    it "constructed for #object" do
      subject.updaters.each do |updater|
        expect(updater.object).to eq subject.object
      end
    end

    it "constructed for #list of methods" do
      expect(subject.updaters.map(&:name)).to eq subject.list
    end

    it "constructed for #code" do
      subject.updaters.each do |updater|
        expect(updater.code).to eq subject.code
      end
    end

  end # describe #updaters

  describe ".run" do

    let(:updaters) { 2.times.map { double run: nil } }
    before { allow(subject).to receive(:updaters).and_return updaters }

    it "runs updaters" do
      updaters.each { |updater| expect(updater).to receive(:run) }
      subject.run
    end

  end # describe .run

end # describe Chronicles::Injector
