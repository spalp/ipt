[#ftl output_format="HTML"]
</head>

[#if auxTopNavbar]
<style>
    body {
        padding-top: 120px;
    }
</style>
[/#if]


<body class="bg-light d-flex flex-column h-100">

<header>
    <nav class="navbar navbar-expand-xl navbar-dark fixed-top bg-dark py-1">
        <div class="container">
            <a href="${baseURL}/" rel="home" title="GBIF Logo" class="navbar-brand" >
                <img src="${baseURL}/images/gbif-logo-L.svg" alt="GBIF IPT" class="gbif-logo"/>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <!-- Navbar -->
                <ul class="navbar-nav me-auto mb-md-0">
                    <li class="nav-item">
                        <a class="nav-link [#if currentMenu=='home']active[/#if]" href="${baseURL}/">[@s.text name="menu.home"/]</a>
                    </li>
                    [#if managerRights]
                        <li class="nav-item">
                            <a class="nav-link [#if currentMenu=='manage']active[/#if]" href="${baseURL}/manage/">[@s.text name="menu.manage"/]</a>
                        </li>
                    [/#if]
                    [#if adminRights]
                        <li class="nav-item">
                            <a class="nav-link [#if currentMenu=='admin']active[/#if]" href="${baseURL}/admin/">[@s.text name="menu.admin"/]</a>
                        </li>
                    [/#if]
                    <li class="nav-item">
                        <a class="nav-link [#if currentMenu=='about']active[/#if]" href="${baseURL}/about.do">[@s.text name="menu.about"/]</a>
                    </li>
                </ul>

                <div class="d-xl-flex align-content-between">
                    <!-- Languages -->
                    <div id="navbarNavDarkDropdown">
                        [#include "/WEB-INF/pages/inc/languages-bootstrap.ftl"/]
                    </div>

                    <!-- Login, account -->
                    [#if (Session.curr_user)??]
                        <ul class="navbar-nav">
                            <li class="nav-item dropdown d-xl-flex align-content-xl-center">
                                <a class="btn btn-sm btn-outline-light menu-link m-xl-auto" id="accountDropdownLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    ${Session.curr_user.email}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-dark text-light" aria-labelledby="accountDropdownLink">
                                    <li>
                                        <a class="dropdown-item menu-link" href="${baseURL}/account.do">
                                            [@s.text name="menu.account"/]
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item menu-link" href="${baseURL}/logout.do">
                                            [@s.text name="menu.logout"/]
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    [#else]
                        <form action="${baseURL}/login.do" method="post" class="d-xl-flex align-content-xl-center">
                            <button class="btn btn-sm btn-outline-light m-xl-auto" type="submit" name="login-submit">
                                [@s.text name="portal.login"/]
                            </button>
                        </form>
                    [/#if]
                </div>
            </div>
        </div>
    </nav>

    [#if auxTopNavbar]
        <nav class="navbar navbar-expand-sm navbar-light fixed-top bg-body shadow-sm py-1" style="position: fixed; top: 50px;">
            <div class="container">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="fieldIndexDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Field Index
                        </a>
                        <ul class="dropdown-menu dropdown-menu-light text-light" aria-labelledby="fieldIndexDropdown">
                            <li><a class="dropdown-item menu-link" href="#">Action 1</a></li>
                            <li><a class="dropdown-item menu-link" href="#">Action 2</a></li>
                            <li><a class="dropdown-item menu-link" href="#">Action 3</a></li>
                        </ul>
                    </li>
                    <li class="nav-item dropdow">
                        <a class="nav-link dropdown-toggle" href="#" id="filtersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Field Filters
                        </a>
                        <ul class="dropdown-menu dropdown-menu-light text-light" aria-labelledby="filtersDropdown">
                            <li><a class="dropdown-item menu-link" href="#">Action 1</a></li>
                            <li><a class="dropdown-item menu-link" href="#">Action 2</a></li>
                            <li><a class="dropdown-item menu-link" href="#">Action 3</a></li>
                        </ul>
                    </li>

                </ul>

                <div class="d-flex align-content-between">
                    <ul class="navbar-nav">
                        <li class="nav-item py-2 px-1">
                            <button class="btn btn-sm btn-outline-success">Save</button>
                        </li>
                        <li class="nav-item py-2 px-1">
                            <button class="btn btn-sm btn-outline-danger">Delete</button>
                        </li>
                        <li class="nav-item py-2 px-1">
                            <button class="btn btn-sm btn-outline-secondary">Back</button>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    [/#if]
</header>

<div id="dialog-confirm" class="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true" style="display: none"></div>
