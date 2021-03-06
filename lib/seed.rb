require 'yaml'

class Seed
    attr_accessor :seed, :official

    def initialize(seed)
        @seed = seed
    end

    def parse
        self.official = create_official

        identifier_obj = @seed["id"]
        identifier = create_identifier(identifier_obj)

        all_terms = @seed["terms"]
        all_terms.each do |term|
            create_term(term)
        end

    end

    def create_official
        new_official = Official.create!(
            first_name: @seed["name"]["first"],
            last_name: @seed["name"]["last"],
            full_name: @seed["name"]["official_full"],
            birthday: @seed["bio"]["birthday"],
            gender: @seed["bio"]["gender"],
            religion: @seed["bio"]["religion"]
        )

        return new_official
    end

    def create_identifier(identifier_obj)
        id = {}
        identifier_obj.each do |key, val|
            id[key] = val unless key == "fec"

            if key == "fec"
                id["fec1"] = "fec"[0]
                id["fec2"] = "fec"[1] if "fec"[1]
            end

        end

        identifier = Identifier.new(id)
        identifier.official = self.official
        identifier.official.bioguide_id = identifier.bioguide
        official.save!
        identifier.save!

        return identifier
    end

    def create_term(term_obj)
        term_hash = {}
        term_obj.each do |key, val|
            next if key == "party_affiliations"
            if key == "type" || key == "class"
                term_hash["term_#{key}"] = val
            else
                term_hash[key] = val
            end
        end

        term = Term.new(term_hash)
        term.official = self.official
        term.save!

        return term
    end

end
