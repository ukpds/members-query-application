require 'rails_helper'

RSpec.describe 'PeopleController', :type => :controller do
  let(:json) { JSON.parse(response.body) }
  let(:xml) { Nokogiri::XML(response.body) }
  let(:rdf) { RDF::NTriples::Reader.new(response.body) }

  describe "GET index" do
    before(:each) do
      @controller = PeopleController.new
      allow(PersonQueryObject).to receive(:all).and_return({graph: PEOPLE_GRAPH, hierarchy: PEOPLE_HASH })
    end

    it 'can render data in json format' do
      get 'index', format: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
      expect(json["people"][1]["id"]).to eq '2'
    end

    it 'can render data in xml format' do
      get 'index', format: :xml

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/xml'
      expect(xml.xpath("//person")[1].children.children[0].content).to eq '2'
    end

    it 'can render data in rdf format' do
      get 'index', format: :rdf

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/rdf+xml'
      expect(rdf.first).to eq PERSON_STATEMENTS[0]
    end

    it 'can does not render data in html format' do
      expect{ get 'index', format: :html }.to raise_error(ActionController::UnknownFormat)
    end
  end

  describe "GET show" do
    before(:each) do
      @controller = PeopleController.new
      allow(PersonQueryObject).to receive(:find).with('http://id.ukpds.org/members/1').and_return({graph: PERSON_ONE_GRAPH, hierarchy: PERSON_ONE_HASH })
    end

    it 'can render data in json format' do
      get 'show', id: 'members/1', format: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
      expect(json["people"][0]["id"]).to eq '1'
    end

    it 'can render data in xml format' do
      get 'show', id: 'members/1', format: :xml

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/xml'
      expect(xml.xpath("//person")[0].children.children[0].content).to eq '1'
    end
  end

end
