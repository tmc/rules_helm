<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#helm_chart"></a>

## helm_chart

<pre>
helm_chart(<a href="#helm_chart-name">name</a>, <a href="#helm_chart-srcs">srcs</a>, <a href="#helm_chart-update_deps">update_deps</a>)
</pre>

Defines a helm chart (directory containing a Chart.yaml).

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="helm_chart-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          A unique name for this rule.
        </p>
      </td>
    </tr>
    <tr id="helm_chart-srcs">
      <td><code>srcs</code></td>
      <td>
        required.
        <p>
          Source files to include as the helm chart. Typically this will just be glob(["**"]).
        </p>
      </td>
    </tr>
    <tr id="helm_chart-update_deps">
      <td><code>update_deps</code></td>
      <td>
        optional. default is <code>False</code>
        <p>
          Whether or not to run a helm dependency update prior to packaging.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#helm_release"></a>

## helm_release

<pre>
helm_release(<a href="#helm_release-name">name</a>, <a href="#helm_release-release_name">release_name</a>, <a href="#helm_release-chart">chart</a>, <a href="#helm_release-values_yaml">values_yaml</a>, <a href="#helm_release-values">values</a>, <a href="#helm_release-namespace">namespace</a>)
</pre>

Defines a helm release.

A given target has the following executable targets generated:

`(target_name).install`
`(target_name).install.wait`
`(target_name).status`
`(target_name).delete`
`(target_name).test`


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="helm_release-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          A unique name for this rule.
        </p>
      </td>
    </tr>
    <tr id="helm_release-release_name">
      <td><code>release_name</code></td>
      <td>
        required.
        <p>
          name of the release.
        </p>
      </td>
    </tr>
    <tr id="helm_release-chart">
      <td><code>chart</code></td>
      <td>
        required.
        <p>
          The chart defined by helm_chart.
        </p>
      </td>
    </tr>
    <tr id="helm_release-values_yaml">
      <td><code>values_yaml</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          The values.yaml file to supply for the release.
        </p>
      </td>
    </tr>
    <tr id="helm_release-values">
      <td><code>values</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          A map of additional values to supply for the release.
        </p>
      </td>
    </tr>
    <tr id="helm_release-namespace">
      <td><code>namespace</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          The namespace to install the release into. If empty will default the NAMESPACE environment variable and will fall back the the current username (via BUILD_USER).
        </p>
      </td>
    </tr>
  </tbody>
</table>
