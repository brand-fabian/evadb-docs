# Software Architecture

EVAdb is built as a collection of perl modules on top of a MySQL database. It
can be split logically into three big parts:

`EVAdb`
:   The main user-facing application for variant filtration, annotation. This
    part will be most often used by normal users aiming to gain insights into
    their datasets.

`Admin Application`
:   The admin application is the backend of EVAdb. It can be used to create
    samples as well as managing data access permissions and relationships
    between groups of or individual samples.

`Solexa Lims System`
:   EVAdb also features a LIMS system for use by wet lab groups. Through this
    interface, additional information for samples can be provided. Most of the
    information relating to this part of the application is retrieved from the
    dna extraction and sequencing processes.

We provide setup and usage guides for EVAdb and the Admin Application here.

## EVAdb

The main user interface of the application. With the user interface provided
by this application users are able to filter variants based on pre-defined
strategies such as autosomal dominant (among others).

## Admin Application

The admin application is used to set meta data and permissions for individual
or groups of samples. Selected users should have access to this part of the
application to manage sample ingress and curate the available data.