require './lib/vending_machine'
require 'pry'
require './lib/product'
  

describe 'VendingMachine' do
  subject {VendingMachine.new}
  
  let(:mint_aero_double) { double :Product, :name => 'Mint Aero', :price => 57 }

  let(:kit_kat_double) { double :Product, :name => 'Kitkat Chunky', :price => 50 }

  context '.restock_coins' do
    it 'allows restock coins method' do
      expect(subject).to respond_to(:restock_coins)
    end
    
    it 'can restock 1p coins' do
      subject.restock_coins(coin_name: '1p', coin_count: 5)
      expect(subject.change['1p']).to eq(5)
    end
  end

  context '.print_coins' do
    it 'allows the print coins method' do
      expect(subject).to respond_to(:print_coins)
    end

    it 'prints out what coins are in the machine' do
      subject.restock_coins(coin_name: '£1', coin_count: 5)
      expect(subject.change['£1']).to eq(5)
    end

    it 'the coin statement has a heading' do
      expect(STDOUT).to receive(:puts).with("coin's value || count")
      expect(STDOUT).to receive(:puts).with("£1 || 5\n")
      subject.restock_coins(coin_name: '£1', coin_count: 5)
      subject.print_coins
    end
  end

  context '.restock_products' do
    it 'allows the restock products method' do
      expect(subject).to respond_to(:restock_products)
    end    

    it 'can restock products' do
      subject.restock_products(product: Product.new(product_name: 'Kitkat Chunky', product_price: 50), product_count: 3)
      expect(subject.products.length).to eq(3)
    end

    it 'can restock different products' do
      subject.restock_products(product: kit_kat_double, product_count: 3)
      subject.restock_products(product: mint_aero_double, product_count: 2)
      expect(subject.products.length).to eq(5)
    end
  end

  context '.product_count' do
    it 'can count number of a specific product' do
      subject.restock_products(product: kit_kat_double, product_count: 3)
      subject.restock_products(product: mint_aero_double, product_count: 2)
      expect(subject.product_count(kit_kat_double)).to eq(3)
    end

    it 'can count number of a different product' do
      subject.restock_products(product: kit_kat_double, product_count: 3)
      subject.restock_products(product: mint_aero_double, product_count: 2)
      expect(subject.product_count(mint_aero_double)).to eq(2)
    end
  end

  context '.print_products' do
    it 'prints products ' do
      expect(subject).to respond_to(:print_products)
    end

    it 'prints out what products are in the machine' do
      expect(STDOUT).to receive(:puts).with("product type || count")
      expect(STDOUT).to receive(:puts).with("Kitkat Chunky || 3")
      subject.restock_products(product: kit_kat_double, product_count: 3)
      subject.print_products
    end

    it 'prints out what products are in the machine - multiple' do
      expect(STDOUT).to receive(:puts).with("product type || count")
      expect(STDOUT).to receive(:puts).with("Kitkat Chunky || 3")
      expect(STDOUT).to receive(:puts).with("Mint Aero || 2")
      subject.restock_products(product: kit_kat_double, product_count: 3)
      subject.restock_products(product: mint_aero_double, product_count: 2)
      subject.print_products
    end
  end

  context '.cash_converts' do
    it 'given an array of coins it can convert it to decimal' do
      subject.restock_coins(coin_name: '1p', coin_count: 3)
      expect(subject.cash_converters(change)).to eq(3)
    end
    
    it 'given a different array of coins it can convert it to decimal' do
      subject.restock_coins(coin_name: '1p', coin_count: 5)
      expect(subject.cash_converters(change)).to eq(5)
    end
  end
end
