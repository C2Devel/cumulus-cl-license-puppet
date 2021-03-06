require 'spec_helper'
require 'pry'

cl_license = Puppet::Type.type(:cumulus_license)

describe cl_license do
  let :params do
    [
      :src,
      :force
    ]
  end

  let :properties do
    [:ensure]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(cl_license.properties.map(&:name)).to be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(cl_license.parameters).to be_include(param)
    end
  end

  context 'validation' do
    context 'src syntax' do
      context 'using puppet:///' do
        it do
          expect do
            cl_license.new(name: 'license',
                           src: 'puppet:///testme')
          end.to raise_error
        end
      end
      context 'using http://' do
        it do
          expect do
            cl_license.new(name: 'license',
                           src: 'http://12345')
          end.to_not raise_error
        end
      end
    end
  end
end
