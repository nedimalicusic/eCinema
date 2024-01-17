using eCinema.Core;

namespace eCinema.Application
{
    public class MovieGenreProfile : BaseProfile
    {
        public MovieGenreProfile()
        {
            CreateMap<MovieGenreDto, MovieGenre>().ReverseMap();

            CreateMap<MovieGenreUpsertDto, MovieGenre>();
        }
    }
}
