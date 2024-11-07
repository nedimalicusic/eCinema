using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class MovieConfiguration : BaseConfiguration<Movie>
    {
        public override void Configure(EntityTypeBuilder<Movie> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Title)
                   .IsRequired();

            builder.Property(e => e.Description)
               .IsRequired();

            builder.Property(e => e.Author)
               .IsRequired();

            builder.Property(e => e.ReleaseYear)
               .IsRequired();

            builder.Property(e => e.Duration)
               .IsRequired();

            builder.Property(e => e.NumberOfViews)
               .IsRequired(false);

            builder.HasOne(e => e.Language)
                   .WithMany(e => e.Movies)
                   .HasForeignKey(e => e.LanguageId)
                   .IsRequired();

            builder.HasOne(e => e.Production)
                   .WithMany(e => e.Movies)
                   .HasForeignKey(e => e.ProductionId)
                   .IsRequired();

            builder.HasOne(e => e.Photo)
                   .WithMany(e => e.Movies)
                   .HasForeignKey(e => e.PhotoId)
                   .IsRequired(false);
        }
    }
}
