require 'test_helper'

module Slingshot

  class SearchTest < Test::Unit::TestCase

    context "Search" do

      should "be initialized with index/indices" do
        assert_raise(ArgumentError) { Search::Search.new }
      end

      should "have the query method" do
        q = Search::Search.new('index').query do;end
        assert_kind_of(Search::Query, q)
      end

      should "store indices as an array" do
        s = Search::Search.new('index1') do;end
        assert_equal ['index1'], s.indices

        s = Search::Search.new('index1', 'index2') do;end
        assert_equal ['index1', 'index2'], s.indices
      end

      should "return curl snippet for debugging" do
        s = Search::Search.new('index') do
          query { query 'title:foo' }
        end
        assert_equal %q|curl -X POST "http://localhost:9200/index/_search?pretty=true" -d | +
                     %q|'{"query":{"query_string":{"query":"title:foo"}}}'|,
                     s.to_curl
      end

      should "perform the search" do
        Configuration.client.expects(:post).returns("{}")
        Results::Collection.expects(:new)
        s = Search::Search.new('index') do
          query { query 'title:foo' }
        end
        s.perform
      end

    end

  end

end