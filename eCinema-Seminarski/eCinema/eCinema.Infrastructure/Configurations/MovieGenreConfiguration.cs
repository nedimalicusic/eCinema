using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class MovieGenreConfiguration : BaseConfiguration<MovieGenre>
    {
        public override void Configure(EntityTypeBuilder<MovieGenre> builder)
        {
            base.Configure(builder);

            builder.HasOne(e => e.Movie)
               .WithMany(e => e.MovieGenres)
               .HasForeignKey(e => e.MovieId)
               .IsRequired();

            builder.HasOne(e => e.Genre)
                   .WithMany(e => e.MovieGenres)
                   .HasForeignKey(e => e.GenreId)
                   .IsRequired();
        }
    }
}
