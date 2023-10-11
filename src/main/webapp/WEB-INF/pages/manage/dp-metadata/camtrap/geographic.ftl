<#-- @ftlvariable name="" type="org.gbif.ipt.action.manage.DataPackageMetadataAction" -->
<#escape x as x?html>
    <#include "/WEB-INF/pages/inc/header.ftl">
    <title><@s.text name='manage.datapackagemetadata.geographic.title'/></title>
    <script src="${baseURL}/js/jconfirmation.jquery.js"></script>
    <script>
        $(document).ready(function(){
            // scroll to the error if present
            var invalidElements = $(".is-invalid");

            if (invalidElements !== undefined && invalidElements.length > 0) {
                var invalidElement = invalidElements.first();
                var pos = invalidElement.offset().top - 100;
                // scroll to the element
                $('body, html').animate({scrollTop: pos});
            }
        });
    </script>
    <#assign currentMenu="manage"/>
    <#assign currentMetadataPage = "geographic"/>
    <#include "/WEB-INF/pages/inc/menu.ftl">
    <#include "/WEB-INF/pages/macros/forms.ftl"/>

    <div class="container px-0">
        <#include "/WEB-INF/pages/inc/action_alerts.ftl">
    </div>

    <form class="needs-validation" action="camtrap-metadata-${section}.do" method="post" novalidate>
        <div class="container-fluid bg-body border-bottom">
            <div class="container bg-body border rounded-2 mb-4">
                <div class="container my-3 p-3">
                    <div class="text-center fs-smaller">
                        <div class="text-center fs-smaller">
                            <nav style="--bs-breadcrumb-divider: url(&#34;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='8'%3E%3Cpath d='M2.5 0L1 1.5 3.5 4 1 6.5 2.5 8l4-4-4-4z' fill='currentColor'/%3E%3C/svg%3E&#34;);" aria-label="breadcrumb">
                                <ol class="breadcrumb justify-content-center mb-0">
                                    <li class="breadcrumb-item"><a href="/manage/"><@s.text name="breadcrumb.manage"/></a></li>
                                    <li class="breadcrumb-item"><a href="resource?r=${resource.shortname}"><@s.text name="breadcrumb.manage.overview"/></a></li>
                                    <li class="breadcrumb-item active" aria-current="page"><@s.text name="breadcrumb.manage.overview.metadata"/></li>
                                </ol>
                            </nav>
                        </div>
                    </div>

                    <div class="text-center">
                        <h1 class="py-2 mb-0 text-gbif-header fs-2 fw-normal">
                            <@s.text name='manage.datapackagemetadata.geographic.title'/>
                        </h1>
                    </div>

                    <div class="text-center fs-smaller">
                        <a href="resource.do?r=${resource.shortname}" title="${resource.title!resource.shortname}">
                            <#if resource.title?has_content>
                                ${resource.title}
                            <#else>
                                ${resource.shortname}
                            </#if>
                        </a>
                    </div>

                    <div class="text-center mt-2">
                        <@s.submit cssClass="button btn btn-sm btn-outline-gbif-primary top-button" name="save" key="button.save"/>
                        <@s.submit cssClass="button btn btn-sm btn-outline-secondary top-button" name="cancel" key="button.back"/>
                    </div>
                </div>
            </div>
        </div>

        <#--        <#include "metadata_section_select.ftl"/>-->

        <div class="container-fluid bg-body">
            <div class="container bd-layout main-content-container">
                <main class="bd-main bd-main">
                    <div class="bd-toc mt-4 mb-5 ps-3 mb-lg-5 text-muted">
                        <#include "metadata_sidebar.ftl"/>
                    </div>

                    <div class="bd-content">
                        <div class="my-md-3 p-3">
                            <p class="mb-2"><@s.text name="datapackagemetadata.geographic.intro"/></p>

                            <div class="row g-2 mt-0">
                                <div class="col-md-6">
                                </div>

                                <div id="preview-links" class="col-md-6">
                                    <div id="dateInferred" class="text-smaller mt-0 d-flex justify-content-end">
                                        <span class="fs-smaller-2" style="padding: 4px;">${(inferredMetadata.lastModified?datetime?string.medium)!}&nbsp;</span>
                                        <a href="camtrap-metadata-geographic.do?r=${resource.shortname}&amp;reinferMetadata=true" class="metadata-action-link">
                                            <span>
                                                <svg class="link-icon" viewBox="0 0 24 24">
                                                    <path d="m19 8-4 4h3c0 3.31-2.69 6-6 6-1.01 0-1.97-.25-2.8-.7l-1.46 1.46C8.97 19.54 10.43 20 12 20c4.42 0 8-3.58 8-8h3l-4-4zM6 12c0-3.31 2.69-6 6-6 1.01 0 1.97.25 2.8.7l1.46-1.46C15.03 4.46 13.57 4 12 4c-4.42 0-8 3.58-8 8H1l4 4 4-4H6z"></path>
                                                </svg>
                                            </span>
                                            <span><@s.text name="datapackagemetadata.reinfer"/></span>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <#if (inferredMetadata.inferredGeographicScope)?? && inferredMetadata.inferredGeographicScope.inferred && !inferredMetadata.inferredGeographicScope.errors?has_content>
                                <input type="hidden" name="metadata.spatial.bbox[0]" value="${inferredMetadata.inferredGeographicScope.minLongitude!}">
                                <input type="hidden" name="metadata.spatial.bbox[1]" value="${inferredMetadata.inferredGeographicScope.minLatitude!}">
                                <input type="hidden" name="metadata.spatial.bbox[2]" value="${inferredMetadata.inferredGeographicScope.maxLongitude!}">
                                <input type="hidden" name="metadata.spatial.bbox[3]" value="${inferredMetadata.inferredGeographicScope.maxLatitude!}">
                            </#if>

                            <div>
                                <div class="table-responsive">
                                    <table class="text-smaller table table-sm table-borderless">
                                        <tr>
                                            <th class="col-4"><@s.text name='datapackagemetadata.geographic.boundingCoordinates'/></th>
                                            <td>
                                                <#if (metadata.spatial.bbox[0])?? && (metadata.spatial.bbox[1])?? && (metadata.spatial.bbox[2])?? && (metadata.spatial.bbox[3])??>
                                                    [${metadata.spatial.bbox[0]}, ${metadata.spatial.bbox[1]}, ${metadata.spatial.bbox[2]}, ${metadata.spatial.bbox[3]}]
                                                <#else>
                                                    -
                                                </#if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-4"><@s.text name='datapackagemetadata.coordinatePrecision'/></th>
                                            <td>${metadata.coordinatePrecision!"0.001"}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </form>

    <#include "/WEB-INF/pages/inc/footer.ftl">
</#escape>
