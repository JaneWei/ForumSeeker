module ApplicationHelper

#Return the full title on a per-page basis.
	def full_title(pageTitle)
			baseTitle = "Forum Deal Seeker"
			if pageTitle.empty?	
					baseTitle
			else 
					"#{baseTitle} | #{pageTitle}"
			end
	end

end
