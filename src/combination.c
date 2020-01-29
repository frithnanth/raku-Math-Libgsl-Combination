#include <gsl/gsl_combination.h>
#include <gsl/gsl_errno.h>
#include <stdio.h>

int mgsl_combination_fwrite(const char *filename, const gsl_combination *p)
{
  FILE *fp;
  if((fp = fopen(filename, "w")) == NULL) return GSL_EFAILED;
  if(gsl_combination_fwrite(fp, p) != GSL_SUCCESS) return GSL_EFAILED;
  fclose(fp);
  return GSL_SUCCESS;
}

int mgsl_combination_fread(const char *filename, gsl_combination *p)
{
  FILE *fp;
  if((fp = fopen(filename, "r")) == NULL) return GSL_EFAILED;
  if(gsl_combination_fread(fp, p) != GSL_SUCCESS) return GSL_EFAILED;
  fclose(fp);
  return GSL_SUCCESS;
}

int mgsl_combination_fprintf(const char *filename, const gsl_combination *p, const char *format)
{
  FILE *fp;
  if((fp = fopen(filename, "w")) == NULL) return GSL_EFAILED;
  if(gsl_combination_fprintf(fp, p, format) != GSL_SUCCESS) return GSL_EFAILED;
  fclose(fp);
  return GSL_SUCCESS;
}

int mgsl_combination_fscanf(const char *filename, gsl_combination *p)
{
  FILE *fp;
  if((fp = fopen(filename, "r")) == NULL) return GSL_EFAILED;
  if(gsl_combination_fscanf(fp, p) != GSL_SUCCESS) return GSL_EFAILED;
  fclose(fp);
  return GSL_SUCCESS;
}
