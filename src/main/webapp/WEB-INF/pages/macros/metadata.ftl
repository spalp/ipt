<script>
$(document).ready(function(){
    var indexOfLastItem = -1;
    var personnelItemsCount = -1;
    var collectionItemsCount = -1;
    var specimenPreservationMethodItemsCount = -1;

    calcIndexOfLastItem();
    calcNumberOfCollectionItems();
    calcNumberOfSpecimenPreservationMethodItems();

    function calcIndexOfLastItem() {
        var lastItem = $("#items .item:last-child").attr("id");
        if (lastItem !== undefined)
            indexOfLastItem = parseInt(lastItem.split("-")[1]);
        else
            indexOfLastItem = -1;
    }

    function calcNumberOfCollectionItems() {
        var lastItem = $("#collection-items .item:last-child").attr("id");
        if (lastItem !== undefined)
            collectionItemsCount = parseInt(lastItem.split("-")[2]);
        else
            collectionItemsCount = -1;
    }

    function calcNumberOfSpecimenPreservationMethodItems() {
        var lastItem = $("#specimenPreservationMethod-items .item:last-child").attr("id");
        if (lastItem !== undefined)
            specimenPreservationMethodItemsCount = parseInt(lastItem.split("-")[2]);
        else
            specimenPreservationMethodItemsCount = -1;
    }

    if ($("#inferTaxonomicCoverageAutomatically").is(':checked')) {
        $("[id^=item-]").remove();
        $('.intro').hide();
        $('#items').hide();
        $('.addNew').hide();
        $('#preview-inferred-taxonomic').hide();
        $('#static-taxanomic').show();
        $('#dateInferred').show();
    }

    $("#inferTaxonomicCoverageAutomatically").click(function() {
        if ($("#inferTaxonomicCoverageAutomatically").is(':checked')) {
            $("[id^=item-]").remove();
            $('.intro').hide();
            $('#items').hide();
            $('.addNew').hide();
            $('#preview-inferred-taxonomic').hide();
            $('#static-taxanomic').show();
            $('#dateInferred').show();
        } else {
            $('.intro').show();
            $('#items').show();
            $('.addNew').show();
            $('#preview-inferred-taxonomic').show();
            $('#static-taxanomic').hide();
        }
    });

    $("#preview-inferred-taxonomic").click(function(event) {
        event.preventDefault();

        $("#dateInferred").show();

        <#if (inferredMetadata.inferredEmlTaxonomicCoverage)?? && inferredMetadata.inferredEmlTaxonomicCoverage.errors?size gt 0>
        $(".metadata-error-alert").show();
        </#if>

        <#if (inferredMetadata.inferredEmlTaxonomicCoverage.data.taxonKeywords)??>
            // remove all current items
            $("[id^=item-]").remove();

            var subItemIndex = 0;
            indexOfLastItem = -1;

            addNewItem(true);

            <#list inferredMetadata.inferredEmlTaxonomicCoverage.data.taxonKeywords as taxon>
                <#if !taxon?is_first>
                    addNewSubItemByIndex(0, "");
                </#if>
                $('#eml\\.taxonomicCoverages\\[0\\]\\.taxonKeywords\\[' + subItemIndex + '\\]\\.scientificName').val("${taxon.scientificName}");
                $('#eml\\.taxonomicCoverages\\[0\\]\\.taxonKeywords\\[' + subItemIndex + '\\]\\.rank').val("${taxon.rank}");
                subItemIndex++;
            </#list>
        </#if>
    });

    function initializeSortableComponent(componentId) {
        sortable('#' + componentId, {
            forcePlaceholderSize: true,
            placeholderClass: 'border',
            exclude: 'input'
        });
    }

    $("#plus").click(function(event) {
        event.preventDefault();
        addNewItem(true);
        initializeSortableComponent("items");
    });

    $("#plus-collection").click(function (event) {
        event.preventDefault();
        addNewCollectionItem(true);
        initializeSortableComponent("collection-items");
    });

    $("#plus-specimenPreservationMethod").click(function (event) {
        event.preventDefault();
        addNewSpecimenPreservationMethodItem(true);
        initializeSortableComponent("specimenPreservationMethod-items");
    });

    $(".removeLink").click(function(event) {
        removeItem(event);
    });

    $(".removeCollectionLink").click(function (event) {
        removeCollectionItem(event);
    });

    $(".removeSpecimenPreservationMethodLink").click(function (event) {
        removeSpecimenPreservationMethodItem(event);
    });
	
	$("[id^=plus-subItem]").click(function(event) {
		addNewSubItem(event);
        var subItemsIndex = event.currentTarget.id.replace("plus-subItem-", "");
        initializeSortableComponent("subItems-" + subItemsIndex);
	});
	
	$("[id^=trash]").click(function(event) {
		removeSubItem(event);
	});
	
	$(".show-taxonList").click(function(event) {
		showList(event);
	});
	
	$("[id^=add-button]").click(function(event) {
		createTaxons(event);
        var subItemsIndex = event.currentTarget.id.replace("add-button-", "");
        initializeSortableComponent("subItems-" + subItemsIndex)
	});

    function addNewSubItem(event, text) {
        event.preventDefault();
        var $target = $(event.target);
        if (!$target.is('a')) {
            $target = $(event.target).closest('a');
        }
        var targetId = $target.attr("id")
        if (!targetId) {
            targetId = $target.prevObject.attr("id");
        }
        addNewSubItemByIndex(targetId.split("-")[2], text);
    }

    function addNewSubItemByIndex(itemIndex, text) {
        var baseItem = $("#item-" + itemIndex);
        // calculating the last taxon index.
        var idBaseItem = baseItem.attr("id");
        var lastIndex = $("#" + idBaseItem + " .sub-item:last-child").attr("id");
        if (lastIndex === undefined) {
            lastIndex = 0;
        } else {
            var splitId = lastIndex.split("-");
            // one or two indexes: subItem-1 or subItem-1-1
            if (splitId.length === 2) {
                lastIndex = parseInt(lastIndex.split("-")[1]) + 1;
            } else {
                lastIndex = parseInt(lastIndex.split("-")[2]) + 1;
            }
        }
        // cloning the taxonItem and setting the corresponding id.
        var subBaseItem = $("#subItem-9999").clone();
        // setting the ids to the rest of the components of the taxomItem
        $("#" + idBaseItem + " #subItems-" + itemIndex).append(subBaseItem);
        // setting the ids to the rest of the components of the taxonItem.
        setSubItemIndex(baseItem, subBaseItem, lastIndex);
        if (text === undefined) {
            subBaseItem.slideDown('slow');
        } else {
            $("#" + baseItem.attr("id") + " #" + subBaseItem.attr("id")).find("[id$='scientificName']").val(text);
            subBaseItem.show();
        }
    }

	function setSubItemIndex(baseItem, subItem, subBaseIndex) {
		<#switch "${section}">
  			<#case "taxcoverage">
                var itemIndex = baseItem[0].id.split("-")[1];
                subItem.attr("id", "subItem-" + itemIndex + "-" + subBaseIndex);
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[id$='scientificName']").attr("id", "eml.taxonomicCoverages[" + baseItem.attr("id").split("-")[1] + "].taxonKeywords[" + subBaseIndex + "].scientificName").attr("name", function () {
                    return $(this).attr("id");
                });
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[for$='scientificName']").attr("for", "eml.taxonomicCoverages[" + baseItem.attr("id").split("-")[1] + "].taxonKeywords[" + subBaseIndex + "].scientificName");
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[id$='commonName']").attr("id", "eml.taxonomicCoverages[" + baseItem.attr("id").split("-")[1] + "].taxonKeywords[" + subBaseIndex + "].commonName").attr("name", function () {
                    return $(this).attr("id");
                });
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[for$='commonName']").attr("for", "eml.taxonomicCoverages[" + baseItem.attr("id").split("-")[1] + "].taxonKeywords[" + subBaseIndex + "].commonName");
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[id$='rank']").attr("id", "eml.taxonomicCoverages[" + baseItem.attr("id").split("-")[1] + "].taxonKeywords[" + subBaseIndex + "].rank").attr("name", function () {
                    return $(this).attr("id");
                });
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[for$='rank']").attr("for", "eml.taxonomicCoverages[" + baseItem.attr("id").split("-")[1] + "].taxonKeywords[" + subBaseIndex + "].rank");
                $("#" + baseItem.attr("id") + " #" + subItem.attr("id")).find("[id^='trash']").attr("id", "trash-" + baseItem.attr("id").split("-")[1] + "-" + subBaseIndex).attr("name", function () {
                    return $(this).attr("id");
                });
                $("#eml\\.taxonomicCoverages\\[" + itemIndex + "\\]\\.taxonKeywords\\[" + subBaseIndex + "\\]\\.rank").select2({
                    placeholder: '${action.getText("eml.rank.selection")?js_string}',
                    language: {
                        noResults: function () {
                            return '${selectNoResultsFound}';
                        }
                    },
                    width: "100%",
                    allowClear: true,
                    theme: 'bootstrap4'
                });
                $("#trash-" + baseItem.attr("id").split("-")[1] + "-" + subBaseIndex).click(function (event) {
                    removeSubItem(event);
                });
                if (subBaseIndex !== 0) {
                    $("#trash-" + baseItem.attr("id").split("-")[1] + "-0").show();
                } else {
                    $("#trash-" + baseItem.attr("id").split("-")[1] + "-" + subBaseIndex).hide();
                }
				<#break>
			<#default>
		</#switch>		
		}

    function removeSubItem(event) {
        event.preventDefault();
        var $target = $(event.target);
        if (!$target.is('a')) {
            $target = $(event.target).closest('a');
        }
        var itemIndex = $target.attr("id").split("-")[1];
        var subItemIndex = $target.attr("id").split("-")[2];
        $("#item-" + itemIndex + " #subItem-" + itemIndex + "-" + subItemIndex).slideUp("fast", function () {
            var indexItem = $(this).find("[id^='trash']").attr("id").split("-")[1];
            $(this).remove();
            $("#item-" + indexItem + " .sub-item").each(function (index) {
                var indexItem = $(this).find("[id^='trash']").attr("id").split("-")[1];
                setSubItemIndex($("#item-" + indexItem), $(this), index);
            });
        });
    }

    function addNewItem(effects){
        var newItem=$('#baseItem').clone();
        if(effects) newItem.hide();
        newItem.appendTo('#items');

        if(effects) {
            newItem.slideDown('slow');
        }

        setItemIndex(newItem, ++indexOfLastItem);

        initInfoPopovers(newItem[0]);
    }

    function addNewCollectionItem(effects){
        var newItem=$('#baseItem-collection').clone();
        if(effects) newItem.hide();
        newItem.appendTo('#collection-items');

        if(effects) {
            newItem.slideDown('slow');
        }

        setCollectionItemIndex(newItem, ++collectionItemsCount);

        initInfoPopovers(newItem[0]);
    }

    function addNewSpecimenPreservationMethodItem(effects){
        var newItem=$('#baseItem-specimenPreservationMethod').clone();
        if(effects) newItem.hide();
        newItem.appendTo('#specimenPreservationMethod-items');

        if(effects) {
            newItem.slideDown('slow');
        }

        setSpecimenPreservationMethodItemIndex(newItem, ++specimenPreservationMethodItemsCount);

        initInfoPopovers(newItem[0]);
    }

    function removeItem(event){
        event.preventDefault();
        var $target = $(event.target);
        if (!$target.is('a')) {
            $target = $(event.target).closest('a');
        }
        $('#item-'+$target.attr("id").split("-")[1]).slideUp('slow', function() {
            $(this).remove();
            $("#items .item").each(function(index) {
                setItemIndex($(this), index);
            });
            calcIndexOfLastItem();
        });
    }

    function removeCollectionItem(event) {
        event.preventDefault();
        var $target = $(event.target);
        if (!$target.is('a')) {
            $target = $(event.target).closest('a');
        }
        $('#collection-item-'+$target.attr("id").split("-")[2]).slideUp('slow', function() {
            $(this).remove();
            $("#collection-items .item").each(function(index) {
                setCollectionItemIndex($(this), index);
            });
            calcNumberOfCollectionItems();
        });
    }

    function removeSpecimenPreservationMethodItem(event) {
        event.preventDefault();
        var $target = $(event.target);
        if (!$target.is('a')) {
            $target = $(event.target).closest('a');
        }
        $('#specimenPreservationMethod-item-'+$target.attr("id").split("-")[2]).slideUp('slow', function() {
            $(this).remove();
            $("#specimenPreservationMethod-items .item").each(function(index) {
                setPreservationMethodItemIndex($(this), index);
            });
            calcNumberOfSpecimenPreservationMethodItems();
        });
    }

    function showList(event) {
        event.preventDefault();
        var $target = $(event.target);
        if (!$target.is('a')) {
            $target = $(event.target).closest('a');
        }
        var targetId = $target.attr("id").split("-")[1];
        $("#list-" + targetId).slideDown('slow', function () {
            $("#taxonsLink-" + targetId).hide();
            $target.parent().children("img").hide();
            $target.parent().children("span").hide();
        });
    }

    function createTaxons(event) {
        event.preventDefault();
        var $target = $(event.target);
        var index = $target.attr("id").split("-")[2];
        var lines = $("#taxon-list-" + index).val().split("\n");
        var line;
        for (var count in lines) {
            line = $.trim(lines[count]);
            if (line !== "undefined" && line !== "") {
                addNewSubItem(event, line);
            }
        }
        $("#taxon-list-" + index).val("");
        $("#list-" + index).slideUp('slow', function () {
            $("#taxonsLink-" + index).show();
            $("#taxonsLink-" + index).parent().children("img").show();
        });
    }
	
	function setItemIndex(item, index){
		item.attr("id","item-"+index);
        $("#item-" + index + " .removeLink").attr("id", "removeLink-" + index);
        $("#removeLink-" + index).click(function (event) {
            removeItem(event);
        });

	    <#switch "${section}">
			<#case "basic">
                $("#item-" + index + " textarea").attr("id",function() {
                    return "eml.description[" + index + "]";
                });
                $("#item-" + index + " textarea").attr("name",function() {
                    return $(this).attr("id");
                });
			<#break>

            <#case "methods">
                $("#item-"+index+" textarea").attr("id", "eml.methodSteps["+index+"]");
                $("#item-"+index+" label").attr("for", "eml.methodSteps["+index+"]");
                $("#item-"+index+" textarea").attr("name", "eml.methodSteps["+index+"]");
                if($("#removeLink-0") != null) {
                    $("#removeLink-0").hide();
                }
            <#break>

            <#case "citations">
                $("#item-"+index+" [id$='citation']").attr("id","eml.bibliographicCitationSet.bibliographicCitations["+index+"].citation");
                $("#item-"+index+" [name$='citation']").attr("name","eml.bibliographicCitationSet.bibliographicCitations["+index+"].citation");
                $("#item-"+index+" [for$='citation']").attr("for","eml.bibliographicCitationSet.bibliographicCitations["+index+"].citation");
                $("#item-"+index+" [id$='identifier']").attr("id","eml.bibliographicCitationSet.bibliographicCitations["+index+"].identifier");
                $("#item-"+index+" [name$='identifier']").attr("name","eml.bibliographicCitationSet.bibliographicCitations["+index+"].identifier");
                $("#item-"+index+" [for$='identifier']").attr("for","eml.bibliographicCitationSet.bibliographicCitations["+index+"].identifier");
            <#break>

            <#case "collections">
                $("#item-" + index + " input").attr("id", function () {
                    var parts = $(this).attr("id").split(".");
                    var n = parseInt(parts.length) - 1;
                    return "eml.jgtiCuratorialUnits[" + index + "]." + parts[n];
                });

                $("#item-" + index + " select").attr("id", "type-" + index).unbind().change(function () {
                    updateSubitem($(this));
                });

                $("#item-" + index + " label").attr("for", function () {
                    var parts = $(this).attr("for").split(".");
                    var n = parseInt(parts.length) - 1;
                    return "eml.jgtiCuratorialUnits[" + index + "]." + parts[n];
                });

                $("#item-" + index + " input").attr("name", function() { return $(this).attr("id"); });
                $("#item-" + index + " select").attr("name", function() { return $(this).attr("id"); });
                $("#item-" + index + " .subitem").attr("id", "subitem-" + index);
                $("#type-" + index).select2({
                    placeholder: '',
                    language: {
                        noResults: function () {
                            return '${selectNoResultsFound}';
                        }
                    },
                    width: "100%",
                    minimumResultsForSearch: 'Infinity',
                    allowClear: false,
                    theme: 'bootstrap4'
                });

                var selectValue = $("#item-" + index + " #type-" + index).val();
                if (selectValue == "COUNT_RANGE") {
                    $("#item-" + index + " [id^='range-']").attr("id", "range-" + index).attr("name", function () {
                        $(this).css("display", "");
                        return $(this).attr("id");
                    });
                } else {
                    $("#item-" + index + " [id^='uncertainty-']").attr("id", "uncertainty-" + index).attr("name", function () {
                        $(this).css("display", "");
                        return $(this).attr("id");
                    });
                }
            <#break>

            <#case "physical">
                $("#item-"+index+" input").attr("id",function() {
                    var parts=$(this).attr("id").split(".");var n=parseInt(parts.length)-1;
                    return "eml.physicalData["+index+"]."+parts[n]; });
                $("#item-"+index+" select").attr("id",function() {
                    var parts=$(this).attr("id").split(".");var n=parseInt(parts.length)-1;
                    return "eml.physicalData["+index+"]."+parts[n]; });
                $("#item-"+index+" label").attr("for",function() {
                    var parts=$(this).attr("for").split(".");var n=parseInt(parts.length)-1;
                    return "eml.physicalData["+index+"]."+parts[n]; });
                $("#item-"+index+" input").attr("name",function() {return $(this).attr("id"); });
                $("#item-"+index+" select").attr("name",function() {return $(this).attr("id"); });
            <#break>

            <#case "keywords">
                $("#item-"+index+" input").attr("id",function() {
                    var parts=$(this).attr("id").split(".");var n=parseInt(parts.length)-1;
                    return "eml.keywords["+index+"]."+parts[n]; });
                $("#item-"+index+" textarea").attr("id",function() {
                    var parts=$(this).attr("id").split(".");var n=parseInt(parts.length)-1;
                    return "eml.keywords["+index+"]."+parts[n]; });
                $("#item-"+index+" select").attr("id",function() {
                    var parts=$(this).attr("id").split(".");var n=parseInt(parts.length)-1;
                    return "eml.keywords["+index+"]."+parts[n]; });
                $("#item-"+index+" label").attr("for",function() {
                    var parts=$(this).attr("for").split(".");var n=parseInt(parts.length)-1;
                    return "eml.keywords["+index+"]."+parts[n]; });
                $("#item-"+index+" input").attr("name",function() {return $(this).attr("id"); });
                $("#item-"+index+" textarea").attr("name",function() {return $(this).attr("id"); });
                $("#item-"+index+" select").attr("name",function() {return $(this).attr("id"); });
            <#break>

            <#case "additional">
                $("#item-"+index+" input").attr("id",function() {
                    return "eml.alternateIdentifiers["+index+"]"; });
                $("#item-"+index+" label").attr("for",function() {
                    return "eml.alternateIdentifiers["+index+"]"; });
                $("#item-"+index+" input").attr("name",function() {return $(this).attr("id"); });
            <#break>

            <#case "taxcoverage">
                $("#item-" + index + " .subItems").attr("id", "subItems-" + index);
                $("#item-" + index + " [id^='plus-subItem']").attr("id", "plus-subItem-" + index);
                $("#plus-subItem-" + index).unbind();
                $("#plus-subItem-" + index).click(function (event) {
                    event.preventDefault();
                    addNewSubItem(event);
                    initializeSortableComponent("subItems-" + index);
                });
                $("#item-" + index + " #subItems-" + index).children(".sub-item").each(function (subindex) {
                    setSubItemIndex($("#item-" + index), $(this), subindex);
                });
                $("#item-" + index + " [id$='description']").attr("id", "eml.taxonomicCoverages[" + index + "].description").attr("name", function () {
                    return $(this).attr("id");
                });
                $("#item-" + index + " [for$='description']").attr("for", "eml.taxonomicCoverages[" + index + "].description");

                $("#item-" + index + " [id^='list']").attr("id", "list-" + index).attr("name", function () {
                    return $(this).attr("id");
                });
                $("#item-" + index + " [id^='taxon-list']").attr("id", "taxon-list-" + index).attr("name", function () {
                    return $(this).attr("id");
                });
                $("#item-" + index + " [id^='taxonsLink']").attr("id", "taxonsLink-" + index);
                $("#taxonsLink-" + index).click(function (event) {
                    showList(event);
                });
                $("#item-" + index + " [id^='add-button']").attr("id", "add-button-" + index).attr("name", function () {
                    return $(this).attr("id");
                });
                $("#add-button-" + index).click(function (event) {
                    createTaxons(event);
                    initializeSortableComponent("subItems-" + index)

                    // update taxon names
                    // take real parent index from name (if item was dragged)
                    var parentRealIndex = $("div#item-" + index + " input[id^='add-button']").attr("name").replace("add-button-", "");
                    var items = $("#item-" + index + " div.sub-item");

                    items.each(function (subIndex) {
                        $("div#subItem-" + index + "-" + subIndex + " input[id$='scientificName']").attr("name", "eml.taxonomicCoverages[" + parentRealIndex + "].taxonKeywords[" + subIndex + "].scientificName");
                        $("div#subItem-" + index + "-" + subIndex + " input[id$='commonName']").attr("name", "eml.taxonomicCoverages[" + parentRealIndex + "].taxonKeywords[" + subIndex + "].commonName");
                        $("div#subItem-" + index + "-" + subIndex + " select[id$='rank']").attr("name", "eml.taxonomicCoverages[" + parentRealIndex + "].taxonKeywords[" + subIndex + "].rank");
                    });
                });
                if ($("#item-" + index + " #subItems-" + index).children().length === 0) {
                    $("#plus-subItem-" + index).click();
                }
		    <#break>
		<#default>
  	  </#switch>		
	}

    function setCollectionItemIndex(item, index) {
        item.attr("id", "collection-item-" + index);

        $("#collection-item-" + index + " [id^='collection-removeLink']").attr("id", "collection-removeLink-" + index);
        $("#collection-removeLink-" + index).click(function (event) {
            removeCollectionItem(event);
        });

        $("#collection-item-" + index + " [id$='collectionName']").attr("id", "eml.collections[" + index + "].collectionName").attr("name", function () {
            return $(this).attr("id");
        });
        $("#collection-item-" + index + " [for$='collectionName']").attr("for", "eml.collections[" + index + "].collectionName");
        $("#collection-item-" + index + " [id$='collectionId']").attr("id", "eml.collections[" + index + "].collectionId").attr("name", function () {
            return $(this).attr("id");
        });
        $("#collection-item-" + index + " [for$='collectionId']").attr("for", "eml.collections[" + index + "].collectionId");
        $("#collection-item-" + index + " [id$='parentCollectionId']").attr("id", "eml.collections[" + index + "].parentCollectionId").attr("name", function () {
            return $(this).attr("id");
        });
        $("#collection-item-" + index + " [for$='parentCollectionId']").attr("for", "eml.collections[" + index + "].parentCollectionId");
    }

    function setSpecimenPreservationMethodItemIndex(item, index) {
        item.attr("id", "specimenPreservationMethod-item-" + index);

        $("#specimenPreservationMethod-item-" + index + " [id^='specimenPreservationMethod-removeLink']").attr("id", "specimenPreservationMethod-removeLink-" + index);
        $("#specimenPreservationMethod-removeLink-" + index).click(function (event) {
            removeSpecimenPreservationMethodItem(event);
        });

        $("#specimenPreservationMethod-item-" + index + " [id$='specimenPreservationMethods']").attr("id", "eml.specimenPreservationMethods[" + index + "]").attr("name", function () {
            return $(this).attr("id");
        });
        $("#specimenPreservationMethod-item-" + index + " [for$='specimenPreservationMethods']").attr("for", "eml.specimenPreservationMethods[" + index + "]");

        $("#eml\\.specimenPreservationMethods\\[" + index + "\\]").select2({
            placeholder: '${action.getText("eml.preservation.methods.selection")?js_string}',
            language: {
                noResults: function () {
                    return '${selectNoResultsFound}';
                }
            },
            width: "100%",
            minimumResultsForSearch: 15,
            allowClear: true,
            theme: 'bootstrap4'
        });
    }
	
	$("[id^='type-']").change(function() {
		updateSubitem($(this));
	});
	
	function updateSubitem(select) {
		<#switch "${section}">
  			<#case "collections">
				var selection = select.val();
				var index = select.attr("id").split("-")[1];
				if(selection == "COUNT_RANGE") {
					$("#subitem-"+index+" [id^='uncertainty-']").fadeOut(function() {
						$(this).remove();
						var newItem = $("#range-99999").clone().css("display", "").attr("id", "range-"+index).attr("name", function() {$(this).attr("id")});
						$("#subitem-"+index).append(newItem).hide().fadeIn(function() {
							setItemIndex($("#item-"+index), index);
						});
					});		
				} else {			
					$("#subitem-"+index+" [id^='range-']").fadeOut(function() {
						$(this).remove();
						var newItem = $("#uncertainty-99999").clone().css("display", "").attr("id", "uncertainty-"+index).attr("name", function() {$(this).attr("id")});
						$("#subitem-"+index).append(newItem).hide().fadeIn(function() {
							setItemIndex($("#item-"+index), index);
						});
					});
				}			
    		<#break>
    		<#default>
    	</#switch>
		
	}
	
});
</script>
