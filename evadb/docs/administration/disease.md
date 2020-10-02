# Diseases and Disease Groups

Diseases and Disease Groups are an important mechanism in EVAdb. Through use of
these features, the system is able to assemble control groups for each query.
By default, on each query for autosomal variants the set of variants is checked
against summary statistics relating to the disease group that the original
sample is part of. To count the number of occurences of a variant in the
database, the current disease group is excluded to allow for finding of
variants that are rare with respect to the general population (we would expect
a disease causing mutation to be more prevalent in the disease group).

!!! hint "Parents"
    In many cases, not only the case is sequenced but also the parents. Such
    trio-analysis cases can be handled through the use of diseases as well.
    If desired, it is possible to have parents and samples in different disease
    groups to have parents as controls. Alternatively, they can be set to the
    same disease group so parents are not included in frequency filters for
    the case.

As such, each sample **must** be annotated with a disease when it is created.
Diseases can be created in the admin application, by using the `New disease`
form.

| Field | Example | Description |
| :--- | :--- | :--- |
| Name | Mitochondriopathy | Name of the disease (used to reference it) |
| Symbol | MT | Short hand dispayed in some results tables |
| OmimID | 590050 | (If available) OmimID corresponding to the disease |
| Disease group | Mitochondrial disease | Disease group |

Disease groups can not be modified through the application. They are hard-coded
within the database.

???- "Disease group table"
    The disease groups are preset in the mariadb database. The default data is
    included in the `exomehg19_diseasegroup.dmp` dump. The disease groups can
    be changed by modifying the table `exomehg19.diseasegroup`. By default, it
    is set by calling the following mysql statement.

    ``` sql
    INSERT INTO `diseasegroup`
    VALUES
      (1,'Neurological disorder'),
      (2,'Developmental disorder'),
      (3,'Eye disease'),
      (4,'Controls'),
      (5,'Mitochondrial disease'),
      (6,'Tumor'),
      (7,'Immunological disorder'),
      (8,'Heart disease'),
      (9,'Lung disease'),
      (10,'Dermatological disease');
    ```

The available disease groups are:

1. Neurological disorder
2. Developmental disorder
3. Eye disease
4. Controls
5. Mitochondrial disease
6. Tumor
7. Immunological disease
8. Heart disease
9. Lung disease
10. Dermatological disease