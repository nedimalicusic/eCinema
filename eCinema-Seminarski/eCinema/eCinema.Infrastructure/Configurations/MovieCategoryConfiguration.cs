using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure.Configurations
{
    public class MovieCategoryConfiguration : BaseConfiguration<MovieCategory>
    {
        public override void Configure(EntityTypeBuilder<MovieCategory> builder)
        {
            base.Configure(builder);

            builder.HasOne(e => e.Movie)
                   .WithMany(e => e.MovieCategories)
                   .HasForeignKey(e => e.MovieId)
                   .IsRequired();

            builder.HasOne(e => e.Category)
                   .WithMany(e => e.MovieCategories)
                   .HasForeignKey(e => e.CategoryId)
                   .IsRequired();
        }
    }
}
