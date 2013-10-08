require 'spec_helper'

describe Beer do
  it "is not saved without a name" do
    beer = Beer.create(style: Style.create(name: "Lager"))

    expect(beer.valid?).to eq(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create(name: "Koff 3")

    expect(beer.valid?).to eq(false)
    expect(Beer.count).to eq(0)
  end
end
