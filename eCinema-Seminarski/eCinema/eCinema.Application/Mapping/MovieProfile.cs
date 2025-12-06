using eCinema.Core;
using eCinema.Core.Dtos.Movie;

namespace eCinema.Application
{
    public class MovieProfile : BaseProfile
    {
        public MovieProfile()
        {
            CreateMap<MovieDto, Movie>();

            CreateMap<Movie, MovieDto>()
                .ForMember(x => x.Categories, options => options.MapFrom(y => y.MovieCategories.Select(z => z.Category)))
                .ForMember(x => x.Genres, options => options.MapFrom(y => y.MovieGenres.Select(z => z.Genre)))
                .ForMember(x => x.Reactions,opt => opt.MapFrom(y => y.MovieReactions))
                .ForMember(x => x.Actors, options => options.MapFrom(y => y.MovieActors.Select(z => z.Actors)));

            CreateMap<MovieUpsertDto, Movie>();

            CreateMap<MovieUpsertDto, MovieUpsertModel>()
              .ForMember(dest => dest.GenreIds, opt => opt.Ignore())
              .ForMember(dest => dest.ActorIds, opt => opt.Ignore())
              .ForMember(dest => dest.CategoryIds, opt => opt.Ignore());

              CreateMap<MovieUpsertModel, MovieUpsertDto>()
              .ForMember(dest => dest.GenreIds, opt => opt.Ignore())
              .ForMember(dest => dest.ActorIds, opt => opt.Ignore())
              .ForMember(dest => dest.CategoryIds, opt => opt.Ignore());
        }
    }
}
