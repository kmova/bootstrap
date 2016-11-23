TARGETS := alpha beta 

#psuedo-target and will not be executed as part as default for make
.nondefault:
	@echo "Execute non-default target"

#beta will be executed first, even though alpha is before
$(TARGETS):
	@echo $@

#Though recipe is defined above, additional dependency is added
alpha: .nondefault

#Overrides the order to execute beta as default
.DEFAULT_GOAL := beta

#Targets are just actions to be performed and are not associated with files
#Improves performance of make, since there is no need to check if the target requires a rebuild
.PHONY: $(TARGETS)
